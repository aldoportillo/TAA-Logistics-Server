class BidsController < ApplicationController
  before_action :set_bid, only: %i[show edit destroy]

  # GET /bids
  def index
    @bids = Bid.all
  end

  # GET /bids/new
  def new
  end

  # POST /bids/upload
  def upload_csv
    uploaded_file = params[:file]
    if uploaded_file.blank?
      redirect_to bids_path, alert: "Please upload a CSV file." and return
    end
  
    file_path = Rails.root.join('tmp', uploaded_file.original_filename)
    File.open(file_path, 'wb') { |file| file.write(uploaded_file.read) }
  
    timestamp = params[:timestamp].presence || Time.current.iso8601
    results_path = ProcessCsvJob.perform_now(file_path, params.to_unsafe_h.merge(timestamp: timestamp))
  
    if File.exist?(results_path)
      processed_filename = File.basename(results_path)
      redirect_to bid_path(id: 'processed', filename: processed_filename), notice: "CSV processed successfully."
    else
      redirect_to bids_path, alert: "There was an issue processing the CSV file."
    end
  end

  # GET /bids/:id
  def show
    if params[:id] == 'processed'
      if params[:filename].blank?
        raise "Missing filename parameter for processed CSV!"
      end
  
      processed_filename = params[:filename]
      csv_file = Rails.root.join('tmp', processed_filename)
      unless File.exist?(csv_file)
        raise "Processed CSV file not found for filename: #{processed_filename}"
      end
  
      @csv_data = CSV.read(csv_file, headers: true)
      @processed_filename = processed_filename
    else
      @bid = Bid.find(params[:id])
    end
  end

  # GET /bids/download_processed_bids
  def download_processed
    if params[:filename].blank?
      raise "Missing filename parameter for download!"
    end
  
    processed_filename = params[:filename]
    file_path = Rails.root.join('tmp', processed_filename)
    if File.exist?(file_path)
      send_file file_path, type: 'text/csv', filename: processed_filename, disposition: 'attachment'
    else
      raise "Processed file not found for filename: #{processed_filename}"
    end
  end

  # DELETE /bids/1
  def destroy
    @bid.destroy!
    respond_to do |format|
      format.html { redirect_to bids_path, status: :see_other, notice: "Bid was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

    def set_bid
      unless params[:id] == 'processed'
        @bid = Bid.find(params[:id])
      end
    end
end

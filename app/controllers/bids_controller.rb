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

    # Save uploaded file to tmp
    file_path = Rails.root.join('tmp', uploaded_file.original_filename)
    File.open(file_path, 'wb') { |file| file.write(uploaded_file.read) }

    # Process the CSV file (this could be a synchronous call or a background job)
    results_path = ProcessCsvJob.perform_now(file_path, params.to_unsafe_h)

    if File.exist?(results_path)
      redirect_to bid_path(id: 'processed'), notice: "CSV processed successfully."
    else
      redirect_to bids_path, alert: "There was an issue processing the CSV file."
    end
  end

  # GET /bids/:id
  # This action serves a dual purpose:
  def show
    if params[:id] == 'processed'
      csv_file = Rails.root.join('tmp', "processed_bids.csv")
      if File.exist?(csv_file)
        # Read CSV data (adjust as needed if the CSV is very large)
        @csv_data = CSV.read(csv_file, headers: true)
      else
        redirect_to bids_path, alert: "Processed CSV not found." and return
      end
    else
      @bid = Bid.find(params[:id])
    end
  end

  # GET /bids/download_processed_bids
  def download_processed
    file_path = Rails.root.join('tmp', "processed_bids.csv")
    if File.exist?(file_path)
      send_file file_path, type: 'text/csv', filename: "processed_bids.csv", disposition: 'attachment'
    else
      redirect_to bids_path, alert: "Processed file not found."
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

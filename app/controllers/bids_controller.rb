class BidsController < ApplicationController
  before_action :set_bid, only: %i[ show edit destroy ]

  # GET /bids or /bids.json
  def index
    @bids = Bid.all
  end

  # GET /bids/new
  def new
  end

  # POST /bids/upload (Handles CSV Upload)
  def upload_csv
    uploaded_file = params[:file]

    if uploaded_file.blank?
      redirect_to bids_path, alert: "Please upload a CSV file."
      return
    end

    # Save uploaded file temporarily
    file_path = Rails.root.join('tmp', uploaded_file.original_filename)
    File.open(file_path, 'wb') { |file| file.write(uploaded_file.read) }

    # Process CSV and get results
    results_path = ProcessCsvJob.perform_now(file_path)

    # Send processed CSV file to the user
    send_file results_path, type: 'text/csv', filename: "processed_bids.csv"
  end

  # DELETE /bids/1 or /bids/1.json
  def destroy
    @bid.destroy!
    respond_to do |format|
      format.html { redirect_to bids_path, status: :see_other, notice: "Bid was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

    def set_bid
      @bid = Bid.find(params[:id])
    end
end

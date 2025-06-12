class PricingMatricesController < ApplicationController
  before_action :set_pricing_matrix, only: %i[ show edit update destroy ]

  # GET /pricing_matrices or /pricing_matrices.json
  def index
    @pricing_matrices = PricingMatrix.all
  end

  # GET /pricing_matrices/1 or /pricing_matrices/1.json
  def show
  end

  # GET /pricing_matrices/new
  def new
    @pricing_matrix = PricingMatrix.new
  end

  # GET /pricing_matrices/1/edit
  def edit
  end

  # POST /pricing_matrices or /pricing_matrices.json
  def create
    @pricing_matrix = PricingMatrix.new(pricing_matrix_params)

    respond_to do |format|
      if @pricing_matrix.save
        format.html { redirect_to @pricing_matrix, notice: "Pricing matrix was successfully created." }
        format.json { render :show, status: :created, location: @pricing_matrix }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @pricing_matrix.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pricing_matrices/1 or /pricing_matrices/1.json
  def update
    respond_to do |format|
      if @pricing_matrix.update(pricing_matrix_params)
        format.html { redirect_to @pricing_matrix, notice: "Pricing matrix was successfully updated." }
        format.json { render :show, status: :ok, location: @pricing_matrix }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @pricing_matrix.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pricing_matrices/1 or /pricing_matrices/1.json
  def destroy
    @pricing_matrix.destroy!

    respond_to do |format|
      format.html { redirect_to pricing_matrices_path, status: :see_other, notice: "Pricing matrix was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pricing_matrix
      @pricing_matrix = PricingMatrix.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def pricing_matrix_params
      params.require(:pricing_matrix).permit(:start_miles, :end_miles, :price)
    end
end

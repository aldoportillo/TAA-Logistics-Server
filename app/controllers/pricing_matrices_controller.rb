class PricingMatricesController < ApplicationController
  before_action :set_pricing_matrix, only: %i[ show edit update destroy ]
  before_action :authorize_pricing_matrix

  # GET /pricing_matrices or /pricing_matrices.json
  def index
    @pricing_matrices = policy_scope(PricingMatrix)
  end

  # GET /pricing_matrices/1 or /pricing_matrices/1.json
  def show
    authorize @pricing_matrix
  end

  # GET /pricing_matrices/new
  def new
    @pricing_matrix = PricingMatrix.new
    authorize @pricing_matrix
  end

  # GET /pricing_matrices/1/edit
  def edit
    authorize @pricing_matrix
  end

  # POST /pricing_matrices or /pricing_matrices.json
  def create
    @pricing_matrix = PricingMatrix.new(pricing_matrix_params)
    authorize @pricing_matrix

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
    authorize @pricing_matrix
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
    authorize @pricing_matrix
    @pricing_matrix.destroy!

    respond_to do |format|
      format.html { redirect_to pricing_matrices_path, status: :see_other, notice: "Pricing matrix was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def authorize_pricing_matrix
      authorize PricingMatrix
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_pricing_matrix
      @pricing_matrix = PricingMatrix.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def pricing_matrix_params
      params.require(:pricing_matrix).permit(:start_miles, :end_miles, :line_haul, :line_haul_plus_29_5_fuel_surcharge)
    end
end

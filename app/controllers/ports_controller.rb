class PortsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_port, only: %i[ show edit update destroy ]

  # GET /ports or /ports.json
  def index
    @ports = policy_scope(Port).order(:name)
  end

  # GET /ports/1 or /ports/1.json
  def show
    authorize @port
  end

  # GET /ports/new
  def new
    @port = Port.new
    authorize @port
  end

  # GET /ports/1/edit
  def edit
    authorize @port
  end

  # POST /ports or /ports.json
  def create
    @port = Port.new(port_params)
    authorize @port

    if @port.save
      redirect_to @port, notice: "Port was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /ports/1 or /ports/1.json
  def update
    authorize @port
    if @port.update(port_params)
      redirect_to @port, notice: "Port was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /ports/1 or /ports/1.json
  def destroy
    authorize @port
    @port.destroy
    redirect_to ports_url, notice: "Port was successfully destroyed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_port
      @port = Port.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def port_params
      params.require(:port).permit(:name, :address, :active)
    end
end

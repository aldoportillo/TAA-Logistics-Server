class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token, only: [:index]

  # GET /events
  def index
    @events = Event.includes(:images).all
  
    formatted_events = @events.map do |event|
      {
        id: event.id,
        name: event.name,
        description: event.description,
        created_at: event.created_at.iso8601,
        updated_at: event.updated_at.iso8601,
        images: event.images.map { |image|
          {
            id: image.id,
            event_id: image.event_id,
            url: image.url,
            created_at: image.created_at.iso8601,
            updated_at: image.updated_at.iso8601
          }
        }
      }
    end
  
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: formatted_events }
    end
  end

  # GET /events/new
  def new
    @event = Event.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: { message: "No view needed for this action" } }
    end
  end

  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: { event: @event, images: @event.images } }
    end
  end

  def edit

  end

  # POST /events
  def create
    authorize Event

    @event = Event.new(event_params)
    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render json: @event, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    authorize @event

    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { render json: @event, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    authorize @event
    
    respond_to do |format|
      format.html
      format.json { render json: { message: "No view needed for this action" } }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_event
    @event = Event.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def event_params
    params.require(:event).permit(:name, :description)
  end
end

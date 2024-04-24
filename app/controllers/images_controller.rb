class ImagesController < ApplicationController

  def create
    authorize Image

    event = Event.find(params[:event_id])
    uploaded_image = Cloudinary::Uploader.upload(params[:image][:file].tempfile.path, folder: "taa/events")

    if uploaded_image.present?
      image = event.images.create(url: uploaded_image['url'])
      if image.persisted?
        redirect_to event_path(event), notice: 'Image was successfully uploaded.'
      else
        render :new, status: :unprocessable_entity, notice: 'There was an error saving the image.'
      end
    else
      redirect_to event_path(event), alert: 'Failed to upload image to Cloudinary.'
    end
  end

  def destroy
    authorize Image
    
    image = Image.find(params[:id])
    if image.destroy
      head :no_content
    else
      render json: { status: 'error', errors: image.errors.full_messages }, status: :unprocessable_entity
    end
  end
end

class DashboardController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_admin!

    def index
      
    end

    def mass_message
      @drivers = User.where(role: 'driver')
      phone_numbers = @drivers.pluck(:phone_number)
      TwilioService.new.send_mass_sms(params[:message], phone_numbers)
  
      redirect_to admin_dashboard_path, notice: "Messages sent successfully to all drivers."
    end

    def mass_message
      message = params[:message]
      drivers = User.where(role: 'driver').pluck(:phone_number)
  
      SendBulkSmsJob.perform_async(message, drivers)
  
      redirect_to admin_dashboard_path, notice: 'Messages are being sent to all drivers.'
    end

    private

    def authorize_admin!
        redirect_to root_path, alert: "Not authorized" unless current_user.admin?
    end

end
  
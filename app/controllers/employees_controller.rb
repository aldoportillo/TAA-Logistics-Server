class EmployeesController < ApplicationController
    #before_action :set_application, only: %i[ show edit update destroy ]

    def index
        @employees = User.all
    end

    def show
        @employee = User.find(params[:id])
        render :show
    end

    def edit
        @employee = User.find(params[:id])
    end

    def update
        @employee = User.find(params[:id])
        if @employee.update(employee_params)
          redirect_to employee_path(@employee), notice: 'Employee was successfully updated.'
        else
          render :edit
        end
    end


    private

    def employee_params
        params.require(:user).permit(:name, :email, :role)
    end
end
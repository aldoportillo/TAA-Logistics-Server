class EmployeesController < ApplicationController
    before_action :set_employee, only: [:show, :edit, :update]
  after_action :verify_authorized

    def index
        @employees = User.all
        authorize User
    end

    def show
        render :show
        authorize @employee
    end

    def edit
        authorize @employee
    end

    def update
        if @employee.update(employee_params)
          redirect_to employee_path(@employee), notice: 'Employee was successfully updated.'
        else
          render :edit
        end
        authorize @employee
    end


    private

    def employee_params
        params.require(:user).permit(:name, :email, :role)
    end

    def set_employee
        @employee = User.find(params[:id])
    end
end
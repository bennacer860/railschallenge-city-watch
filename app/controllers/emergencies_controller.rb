class EmergenciesController < ApplicationController
  def create
    @emergency = Emergency.new(emergency_create_params)
    if @emergency.save
      render json: { emergency: @emergency }, status: :created
    else
      render json: { message: @emergency.errors }, status: 422
    end
  end

  private

  def emergency_create_params
    params.require(:emergency).permit(:code, :fire_severity, :police_severity, :medical_severity)
  end

end

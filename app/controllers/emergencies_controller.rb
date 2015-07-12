class EmergenciesController < ApplicationController
  def create
    @emergency = Emergency.new(emergency_create_params)
    if @emergency.save
      render json: { emergency: @emergency }, status: :created
    else
      render json: { message: @emergency.errors }, status: 422
    end
  end

  def index
    @emergencies = Emergency.all
    render json: { emergencies: @emergencies }, status: :ok
  end

  def update
    @emergency = Emergency.find_by_code!(params[:id])
    if @emergency.update(emergency_update_params)
      render json: { emergency: @emergency }, status: :ok
    else
      render json: { emergency: @emergency.errors }, status: :unprocessable_entity
    end
  end

  def show
    @emergency = Emergency.find_by_code(params[:id])
    if @emergency
      render json: { emergency: @emergency }, status: :ok
    else
      render json: { message: 'non-existent-responder-name' }, status: :not_found
    end
  end

  def destroy
    render json: { message: 'page not found' }, status: :not_found
  end

  def edit
    render json: { message: 'page not found' }, status: :not_found
  end

  def new
    render json: { message: 'page not found' }, status: :not_found
  end

 def new
    render json: { message: 'page not found' }, status: :not_found
  end

  private

  def emergency_create_params
    params.require(:emergency).permit(:code, :fire_severity, :police_severity, :medical_severity)
  end

  def emergency_update_params
    params.require(:emergency).permit(:code, :fire_severity, :police_severity, :medical_severity)
  end
end

class RespondersController < ApplicationController
  def index
    @responders = Responder.all.map { |responder| format_show_responder(responder) }
    render json: { responders: responders }, status: :ok
  end

  def new
    render json: { message: 'page not found' }, status: :not_found
  end

  def create
    @responder = Responder.new(responder_create_params)
    if @responder.save
      render json: @responder, status: :created
    else
      render json: { message: @responder.errors.messages }, status: :unprocessable_entity
    end
  end

  def update
    @responder = Responder.find_by_name!(params[:id])
    if @responder.update(responder_update_params)
      render json: { responder: format_show_responder(@responder) }, status: :ok
    else
      render json: { message: @responder.errors }, status: :unprocessable_entity
    end
  end

  def show
    @responder = Responder.find_by_name(params[:id])
    if @responder
      render json: { responder: format_show_responder(@responder) }, status: :ok
    else
      render json: { message: 'non-existent-responder-name' }, status: :not_found
    end
  end

  def edit
    render json: { message: 'page not found' }, status: :not_found
  end

  def destroy
    render json: { message: 'page not found' }, status: :not_found
  end

  private

  def responder_create_params
    params.require(:responder).permit(:type, :name, :capacity)
  end

  def responder_update_params
    params.require(:responder).permit(:on_duty)
  end

  def format_show_responder(responder)
    responder.attributes.select { |k| %w(emergency_code type name capacity on_duty).include?(k) }
  end
end

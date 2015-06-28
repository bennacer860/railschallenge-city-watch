class RespondersController < ApplicationController
  def create
    @responder = Responder.new(responder_create_params)
    if @responder.save
      render json: @responder, status: :created
    else
      render json: { message: @responder.errors.messages }, status: :unprocessable_entity
    end
  end

  def show
    responder = Responder.find_by_name(params[:id])
    if responder
      render json: { responder: format_show_responder(responder) }
    else
      render json: { message: 'non-existent-responder-name' }, status: :not_found
    end
  end

  private

  def responder_create_params
    params.require(:responder).permit(:type, :name, :capacity)
  end

  def format_show_responder(responder)
    responder.attributes.select { |k| %w(emergency_code type name capacity on_duty).include?(k) }
  end
end

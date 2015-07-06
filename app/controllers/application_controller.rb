class ApplicationController < ActionController::Base
  rescue_from ActionController::UnpermittedParameters, with: :unpermitted_parameters

  def unpermitted_parameters(exception)
    render json: { message: exception.message  }, status: :unprocessable_entity
  end
end

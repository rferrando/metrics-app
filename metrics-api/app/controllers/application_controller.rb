class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :handle_unprocessable_entity
  rescue_from StandardError, with: :handle_internal_server_error

  private

  def handle_not_found(exception)
    Rails.logger.debug("Error: #{exception.message}")
    render json: exception.message, status: :not_found
  end

  def handle_unprocessable_entity(exception)
    Rails.logger.debug("Error: #{exception.message}")
    render json: exception.message, status: :unprocessable_entity
  end

  def handle_internal_server_error(exception)
    Rails.logger.debug("Error: #{exception.message}")
    render json: exception.message, status: :internal_server_error
  end
end

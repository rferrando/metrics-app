require_relative '../services/api_error'
class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :handle_unprocessable_entity
  rescue_from StandardError, with: :handle_internal_server_error
  rescue_from ActionController::ParameterMissing, with: :handle_bad_request
  rescue_from ApiError, with: :render_api_error

  private

  def handle_not_found(exception)
    Rails.logger.error("Error: #{exception.message}")
    render json: {error: exception.message}, status: :not_found
  end

  def handle_bad_request(exception)
    Rails.logger.error("Error: #{exception.message}")
    render json: {error: exception.message}, status: :bad_request
  end

  def handle_unprocessable_entity(exception)
    Rails.logger.error("Error: #{exception.message}")
    render json: {error: exception.message}, status: :unprocessable_entity
  end

  def handle_internal_server_error(exception)
    Rails.logger.error("Error: #{exception.message}")
    render json: {error: exception.message}, status: :internal_server_error
  end

  def render_api_error(exception)
    Rails.logger.error("Error: #{exception.message}")
    render json: {error: exception.message}, status: exception.status
  end
end

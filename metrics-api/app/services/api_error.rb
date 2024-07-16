class ApiError < StandardError
  attr_reader :status, :message

  def initialize(status: 500, message: 'Something went wrong')
    @status = status
    @message = message
  end
end

class ValidationError < ApiError
  def initialize(message = 'Validation failed:')
    super(status: 500, message: message)
  end
end

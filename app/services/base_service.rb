class BaseService

  SUCCESS = 'success'.freeze
  FAILURE = 'failure'.freeze
  RESULT = Struct.new(:data, :status, :errors)

  def initialize(result = RESULT.new(nil, nil, []))
    @result = result
  end

  attr_reader :result

  def data
    result.data
  end

  def status
    result.status
  end

  def errors
    result.errors
  end

  def success(data = nil)
    result.data = data
    result.status = SUCCESS
    BaseService.new(result)
  end

  def failure(data = nil)
    result.data = data
    result.status = FAILURE
    BaseService.new(result)
  end

  def success?
    result.status == SUCCESS
  end

  def failure?
    result.status == FAILURE
  end

  def errors?
    result.errors.any?
  end

  def add_error(error)
    result.errors << error
  end

  def add_errors(errors)
    result.errors += errors
  end

  def error_messages
    result.errors.try(:messages) || result.errors.map { |error| error.try(:messages) || error.try(:message) }.compact
  end

end

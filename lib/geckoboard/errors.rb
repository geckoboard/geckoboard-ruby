module Geckoboard
  BaseError             = Class.new(StandardError)
  UnauthorizedError     = Class.new(BaseError)
  UnexpectedStatusError = Class.new(BaseError)
end

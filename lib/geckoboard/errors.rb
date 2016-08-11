module Geckoboard
  BaseError             = Class.new(StandardError)
  BadRequestError       = Class.new(BaseError)
  ConflictError         = Class.new(BaseError)
  UnauthorizedError     = Class.new(BaseError)
  UnexpectedStatusError = Class.new(BaseError)
end

module Geckoboard
  class Connection
    attr_reader :api_key

    def initialize(api_key)
      @api_key = api_key
    end

    def get(path)
      request = Net::HTTP::Get.new(path)

      make_request(request)
    end

    def delete(path)
      request = Net::HTTP::Delete.new(path)

      make_request(request)
    end

    def put(path, body)
      request = Net::HTTP::Put.new(path)
      request['Content-Type'] = 'application/json'
      request.body = body

      make_request(request)
    end

    private

    def make_request(request)
      request.basic_auth(api_key, '')
      request['User-Agent'] = USER_AGENT

      response = http.request(request)
      check_for_errors(response)
      response
    end

    def check_for_errors(response)
      return if response.code.to_i < 400

      error_message = extract_error_message(response) ||
        "Server responded with unexpected status code (#{response.code})"

      exception = case response
                  when Net::HTTPUnauthorized then UnauthorizedError
                  when Net::HTTPConflict     then ConflictError
                  when Net::HTTPBadRequest   then BadRequestError
                  else UnexpectedStatusError
                  end

      raise exception, error_message
    end

    def extract_error_message(response)
      return unless response_is_json? response

      JSON.parse(response.body)
        .fetch('error', {})
        .fetch('message', nil)
    end

    def response_is_json?(response)
      (response['Content-Type'] || '').split(';').first == 'application/json'
    end

    def http
      http = Net::HTTP.new('api.geckoboard.com', 443)
      http.use_ssl = true
      http
    end
  end
end

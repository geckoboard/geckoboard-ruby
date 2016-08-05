module Geckoboard
  class Client
    attr_reader :api_key

    def initialize(api_key)
      @api_key = api_key
    end

    def ping
      http = Net::HTTP.new('api.geckoboard.com', 443)
      http.use_ssl = true

      request = Net::HTTP::Get.new('/')
      request.basic_auth(api_key, '')

      response = http.request(request)

      case response
      when Net::HTTPOK
        true
      when Net::HTTPUnauthorized
        raise UnauthorizedError, extract_error_message(response)
      else
        raise UnexpectedStatusError, "Server responded with unexpected status code (#{response.code})"
      end
    end

    private

    def extract_error_message(response)
      JSON.parse(response.body)
        .fetch('error', {})
        .fetch('message', nil)
    end
  end
end

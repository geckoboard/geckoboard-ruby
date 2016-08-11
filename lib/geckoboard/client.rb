module Geckoboard
  class Client
    USER_AGENT = "Geckoboard-Ruby/#{VERSION}"

    attr_reader :api_key

    def initialize(api_key)
      @api_key = api_key
    end

    def ping
      http = Net::HTTP.new('api.geckoboard.com', 443)
      http.use_ssl = true

      request = Net::HTTP::Get.new('/')
      request.basic_auth(api_key, '')
      request['User-Agent'] = USER_AGENT

      response = http.request(request)

      case response
      when Net::HTTPOK
        true
      when Net::HTTPUnauthorized
        raise UnauthorizedError, extract_error_message(response)
      else
        error_message = extract_error_message(response) ||
          "Server responded with unexpected status code (#{response.code})"

        raise UnexpectedStatusError, error_message
      end
    end

    private

    def extract_error_message(response)
      return unless response_is_json? response

      JSON.parse(response.body)
        .fetch('error', {})
        .fetch('message', nil)
    end

    def response_is_json?(response)
      response['Content-Type'] == 'application/json'
    end
  end
end

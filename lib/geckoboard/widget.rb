module Geckoboard
  class Widget
    attr_reader :widget_key

    def initialize(widget_key)
      @widget_key = widget_key
    end

    def post(data)
      RestClient.post("https://push.geckoboard.com/v1/send/#{widget_key}", {
          api_key: ENV['GECKOBOARD_KEY'],
          data: data
        }.to_json, content_type: :json, accept: :json)
    end
  end
end

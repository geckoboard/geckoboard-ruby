module Geckoboard
  class Client
    attr_reader :connection

    def initialize(api_key)
      @connection = Connection.new(api_key)
    end

    def ping
      connection.get('/')
      true
    end

    def datasets
      Datasets.new(connection)
    end
  end
end

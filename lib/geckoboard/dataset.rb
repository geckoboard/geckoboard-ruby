module Geckoboard
  class Dataset
    attr_reader :client, :id, :fields

    def initialize(client, id, fields)
      @client = client
      @id     = id
      @fields = fields
    end

    def delete
      client.delete(id)
    end

    def put(data)
      client.put_data(id, payload_formatter.format(data))
    end

    private

    def payload_formatter
      PayloadFormatter.new(self)
    end
  end
end

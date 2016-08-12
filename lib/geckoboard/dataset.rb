module Geckoboard
  class Dataset
    attr_reader :client, :id

    def initialize(client, id)
      @client = client
      @id     = id
    end

    def delete
      client.delete(id)
    end
  end
end

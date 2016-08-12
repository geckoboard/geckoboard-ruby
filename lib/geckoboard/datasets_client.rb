module Geckoboard
  class DatasetsClient
    attr_reader :connection

    def initialize(connection)
      @connection = connection
    end

    def find_or_create(dataset_id, fields: {})
      path = dataset_path(dataset_id)
      response = connection.put(path, { fields: fields }.to_json)

      data = JSON.parse(response.body)
      Dataset.new(self, data.fetch('id'), data.fetch('fields'))
    end

    def delete(dataset_id)
      path = dataset_path(dataset_id)
      connection.delete(path)
      true
    end

    def put_data(dataset_id, data)
      path = "#{dataset_path(dataset_id)}/data"
      connection.put(path, { data: data }.to_json)
      true
    end

    private

    def dataset_path(dataset_id)
      "/datasets/#{CGI.escape(dataset_id)}"
    end
  end
end

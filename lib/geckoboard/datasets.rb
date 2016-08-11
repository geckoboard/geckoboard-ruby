module Geckoboard
  class Datasets
    attr_reader :connection

    def initialize(connection)
      @connection = connection
    end

    def find_or_create(dataset_id, fields: fields)
      path = dataset_path(dataset_id)
      response = connection.put(path, { fields: fields }.to_json)
      Dataset.new(JSON.parse(response.body).fetch('id'))
    end

    private

    def dataset_path(dataset_id)
      "/datasets/#{CGI.escape(dataset_id)}"
    end
  end
end

require 'spec_helper'

module Geckoboard
  describe Dataset do
    describe '#delete' do
      it 'calls #delete on the client' do
        client = double(:client)
        dataset_id = 'sales.gross'

        expect(client).to receive(:delete).with(dataset_id)

        dataset = Dataset.new(client, dataset_id)
        dataset.delete
      end
    end
  end
end

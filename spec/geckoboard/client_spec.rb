require 'spec_helper'

module Geckoboard
  describe Client do
    let(:api_key) { '222efc82e7933138077b1c2554439e15' }

    subject { Client.new(api_key) }

    describe '#ping' do
      specify 'returns true when server responds with 200' do
        stub_endpoint.to_return(
          status: 200,
          body: '{}'
        )

        expect(subject.ping).to eq(true)
      end

      specify 'raises UnauthorizedError when the server responds with 401' do
        error_message = 'Your API key is invalid'

        stub_endpoint.to_return(
          status: 401,
          body: {
            error: {
              message: error_message
            }
          }.to_json
        )

        expect { subject.ping }.to raise_error(UnauthorizedError, error_message)
      end

      def stub_endpoint
        stub_request(:get, 'https://api.geckoboard.com/')
          .with(basic_auth: [api_key, ''])
      end
    end
  end
end

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

      specify 'raises UnexpectedStatusError when the server responds with an unexpected status code' do
        stub_endpoint.to_return(status: 418)
        expect { subject.ping }.to raise_error(UnexpectedStatusError, 'Server responded with unexpected status code (418)')
      end

      def stub_endpoint
        stub_request(:get, 'https://api.geckoboard.com/')
          .with(basic_auth: [api_key, ''], headers: { 'User-Agent' => Client::USER_AGENT })
      end
    end
  end
end

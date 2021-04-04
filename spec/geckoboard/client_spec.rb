require 'spec_helper'

module Geckoboard
  describe Client do
    let(:api_key) { '222efc82e7933138077b1c2554439e15' }

    subject { Client.new(api_key) }

    shared_examples :bad_response_exceptions do
      specify 'raises UnauthorizedError when the server responds with a 401' do
        error_message = 'Your API key is invalid'

        stub_endpoint.to_return(
          status: 401,
          headers: {
            'Content-Type' => 'application/json'
          },
          body: {
            error: {
              message: error_message
            }
          }.to_json
        )

        expect { make_request }.to raise_error(UnauthorizedError, error_message)
      end

      specify 'raises BadRequestError when the server responds with a 400' do
        stub_endpoint.to_return(status: 400)
        expect { make_request }.to raise_error(BadRequestError)
      end

      specify 'raises ConflictError when the server responds with a 409' do
        stub_endpoint.to_return(status: 409)
        expect { make_request }.to raise_error(ConflictError)
      end

      specify 'raises UnexpectedStatusError when the server responds with an unexpected status code' do
        stub_endpoint.to_return(status: 418)
        expect { make_request }.to raise_error(UnexpectedStatusError, 'Server responded with unexpected status code (418)')
      end
    end

    describe '#ping' do
      include_examples :bad_response_exceptions

      specify 'returns true when server responds with 200' do
        stub_endpoint.to_return(
          status: 200,
          headers: {
            'Content-Type' => 'application/json'
          },
          body: '{}'
        )

        expect(make_request).to eq(true)
      end

      def make_request
        subject.ping
      end

      def stub_endpoint
        stub_request(:get, 'https://api.geckoboard.com/')
          .with(basic_auth: [api_key, ''], headers: { 'User-Agent' => USER_AGENT })
      end
    end

    describe '#datasets' do
      let(:fields_hash) do
        {
          amount: {
            name: 'Amount',
            optional: false,
            type: :number,
          },
          timestamp: {
            name: 'Time',
            type: :datetime,
          }
        }
      end

      describe '#find_or_create' do
        let(:request_body) do
          { fields: fields_hash }
        end

        context 'with a fields hash' do
          include_examples :bad_response_exceptions

          specify 'returns the found or created Dataset object' do
            stub_endpoint.to_return(
              status: 201,
              headers: {
                'Content-Type' => 'application/json'
              },
              body: {
                id: 'sales.gross',
                fields: fields_hash
              }.to_json
            )
            dataset = make_request
            expect(dataset.id).to eq('sales.gross')
          end

          def make_request
            subject.datasets.find_or_create('sales.gross', fields: fields_hash)
          end
        end

        context 'with a collection of field objects' do
          include_examples :bad_response_exceptions

          let(:fields_hash) do
            {
              amount: {
                name: 'Amount',
                optional: false,
                type: :number,
              },
              timestamp: {
                name: 'Time',
                type: :datetime,
              },
              cost: {
                name: 'Cost',
                optional: false,
                type: :money,
                currency_code: 'USD',
              },
              span: {
                name: 'Span'
                optional: false,
                type: :duration,
                time_unit: 'seconds',
              },
              completion: {
                name: 'Completion'
                optional: false,
                type: :percentage,
              },
              company: {
                name: 'Company'
                optional: false,
                type: :string,
              }
            }
          end

          specify 'returns the found or created Dataset object' do
            stub_endpoint.to_return(
              status: 201,
              headers: {
                'Content-Type' => 'application/json'
              },
              body: {
                id: 'sales.gross',
                fields: fields_hash
              }.to_json
            )
            dataset = make_request
            expect(dataset.id).to eq('sales.gross')
          end

          def make_request
            subject.datasets.find_or_create('sales.gross', fields: [
              Geckoboard::NumberField.new(:amount, name: 'Amount'),
              Geckoboard::DateTimeField.new(:timestamp, name: 'Time'),
              Geckoboard::MoneyField.new(:cost, name: 'Cost', currency_code: 'USD'),
              Geckoboard::DurationField.new(:span, name: 'Span', time_unit: 'seconds'),
              Geckoboard::PercentageField.new(:completion, name: 'Completion'),
              Geckoboard::StringField.new(:company, name: 'Company')
            ])
          end
        end

        context 'with the optional `unique_by` parameter' do
          include_examples :bad_response_exceptions

          let(:unique_by) { ['datetime'] }
          let(:request_body) do
            { fields: fields_hash, unique_by: unique_by }
          end

          specify 'returns the found or created Dataset object' do
            stub_endpoint.to_return(
              status: 201,
              headers: {
                'Content-Type' => 'application/json'
              },
              body: {
                id: 'sales.gross',
                fields: fields_hash,
                unique_by: unique_by,
              }.to_json
            )
            dataset = make_request
            expect(dataset.id).to eq('sales.gross')
          end

          def make_request
            subject.datasets.find_or_create('sales.gross', fields: fields_hash, unique_by: unique_by)
          end
        end

        context 'with optional fields' do
          let(:fields_hash) do
            {
              amount: {
                name: 'Amount',
                optional: true,
                type: :number,
              },
              timestamp: {
                name: 'Time',
                type: :datetime,
              },
              cost: {
                name: 'Cost',
                optional: true,
                type: :money,
                currency_code: 'USD',
              },
              completion: {
                name: 'Completion',
                optional: true,
                type: :percentage,
              },
              company: {
                name: 'Company',
                optional: true,
                type: :string,
              }
            }
          end

          specify 'returns the found or created Dataset object' do
            stub_endpoint.to_return(
              status: 201,
              headers: {
                'Content-Type' => 'application/json'
              },
              body: {
                id: 'sales.gross',
                fields: fields_hash
              }.to_json
            )
            dataset = make_request
            expect(dataset.id).to eq('sales.gross')
          end

          def make_request
            subject.datasets.find_or_create('sales.gross', fields: [
              Geckoboard::NumberField.new(:amount, name: 'Amount', optional: true),
              Geckoboard::DateTimeField.new(:timestamp, name: 'Time'),
              Geckoboard::MoneyField.new(:cost, name: 'Cost', currency_code: 'USD', optional: true),
              Geckoboard::DurationField.new(:span, name: 'Duration', time_unit: 'seconds', optional: true),
              Geckoboard::PercentageField.new(:completion, name: 'Completion', optional: true),
              Geckoboard::StringField.new(:company, name: 'Company', optional: true)
            ])
          end
        end

        def stub_endpoint
          stub_request(:put, 'https://api.geckoboard.com/datasets/sales.gross')
            .with({
              body: request_body.to_json,
              basic_auth: [api_key, ''],
              headers: {
                'User-Agent' => USER_AGENT,
                'Content-Type' => 'application/json'
              }
            })
        end
      end

      describe '#delete' do
        include_examples :bad_response_exceptions

        specify 'returns true when server responds with 200' do
          stub_endpoint.to_return(
            status: 200,
            headers: {
              'Content-Type' => 'application/json'
            },
            body: '{}'
          )

          expect(make_request).to eq(true)
        end

        def make_request
          subject.datasets.delete('sales.gross')
        end

        def stub_endpoint
          stub_request(:delete, 'https://api.geckoboard.com/datasets/sales.gross')
            .with({
              basic_auth: [api_key, ''],
              headers: { 'User-Agent' => USER_AGENT }
            })
        end
      end

      describe '#put' do
        include_examples :bad_response_exceptions

        let(:data) do
          [
            {
              'timestamp' => '2016-01-01T12:00:00Z',
              'amount'    => 819
            },
            {
              'timestamp' => '2016-01-02T12:00:00Z',
              'amount'    => 409
            }
          ]
        end

        specify 'returns true when server responds with 200' do
          stub_endpoint.to_return(
            status: 200,
            headers: {
              'Content-Type' => 'application/json'
            },
            body: '{}'
          )

          expect(make_request).to eq(true)
        end

        def make_request
          stub_request(:put, 'https://api.geckoboard.com/datasets/sales.gross')
            .to_return(
              status: 201,
              headers: {
                'Content-Type' => 'application/json'
              },
              body: {
                id: 'sales.gross',
                fields: fields_hash
              }.to_json
            )

          dataset = subject.datasets.find_or_create('sales.gross', fields: fields_hash)
          dataset.put(data)
        end

        def stub_endpoint
          stub_request(:put, 'https://api.geckoboard.com/datasets/sales.gross/data')
            .with({
              body: { data: data }.to_json,
              basic_auth: [api_key, ''],
              headers: { 'User-Agent' => USER_AGENT }
            })
        end
      end

      describe '#post' do
        include_examples :bad_response_exceptions

        let(:data) do
          [
            {
              'timestamp' => '2016-01-01T12:00:00Z',
              'amount'    => 819
            },
            {
              'timestamp' => '2016-01-02T12:00:00Z',
              'amount'    => 409
            }
          ]
        end
        let(:request_body) do
          { data: data }
        end

        specify 'returns true when server responds with 200' do
          stub_endpoint.to_return(
            status: 200,
            headers: {
              'Content-Type' => 'application/json'
            },
            body: '{}'
          )

          expect(make_request).to eq(true)
        end

        context 'with the optional `delete_by` parameter' do
          let(:request_body) do
            { delete_by: 'timestamp', data: data }
          end

          specify 'makes the appropriate request' do
            stub_endpoint.to_return(
              status: 200,
              headers: {
                'Content-Type' => 'application/json'
              },
              body: '{}'
            )

            expect(make_request).to eq(true)
          end

          def make_request
            make_dataset.post(data, delete_by: 'timestamp')
          end
        end

        def make_request
          make_dataset.post(data)
        end

        def stub_endpoint
          stub_request(:post, 'https://api.geckoboard.com/datasets/sales.gross/data')
            .with({
              body: request_body.to_json,
              basic_auth: [api_key, ''],
              headers: { 'User-Agent' => USER_AGENT }
            })
        end

        def make_dataset
          stub_request(:put, 'https://api.geckoboard.com/datasets/sales.gross')
            .to_return(
              status: 201,
              headers: {
                'Content-Type' => 'application/json'
              },
              body: {
                id: 'sales.gross',
                fields: fields_hash
              }.to_json
            )

          subject.datasets.find_or_create('sales.gross', fields: fields_hash)
        end
      end
    end
  end
end

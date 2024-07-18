require 'swagger_helper'

RSpec.describe 'Metrics API', type: :request do

  path '/metrics/generate_random_data' do

    post('Generate random values for 3 kind of metrics') do 
      tags 'Metrics'
      parameter name: 'num_metrics', in: :path, type: :number, description: 'number of metrics to be generated', example: 100

      response(200, 'successful') do
        schema type: :object,
          properties: {
            message: { type: :string, example: "Random metrics generated successfully" }
          }
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end

  path '/metrics' do

    post('Creates a metric') do
      tags 'Metrics'
      consumes 'application/json'
      parameter name: :metric, in: :body,
      required: true,
      schema: {
          type: :object,
          properties: {
            name: { type: :string, example: 'cpu'},
            value: { type: :number, format: :float , example: 75.55 },
            timestamp: { type: :string, format: 'date-time', default: Time.now.iso8601, example:''}
          },
          required: [ 'name', 'value']
        }

      
      response(201, 'created') do
        schema type: :object,
          properties: {
            id: { type: :integer, example: 1 },
            name: { type: :string, example: 'cpu'},
            value: { type: :number, format: :float , example: 75.55 },
            timestamp: { type: :string, format: 'date-time', example:Time.now.iso8601},
            created_at: { type: :string, format: :date_time, example: Time.now.iso8601 },
            updated_at: { type: :string, format: :date_time, example: Time.now.iso8601 },
          }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end

      response(400, 'bad request') do
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end

      response(422, 'invalid request') do
        schema type: :object,
          properties: {
            error: { type: :string, example: "Timestamp should be a DateTime" }
          }
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end
end

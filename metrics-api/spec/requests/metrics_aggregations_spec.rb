require 'swagger_helper'

RSpec.describe 'Metric aggregations API', type: :request do

  path '/metrics_aggregations/by_minute' do

    get('Fetch aggregated metrics by minute within a date range') do
      tags 'Aggregations'
      produces 'application/json'
      parameter name: :params, in: :query, 
      required: true,
      schema: {
          type: :object,
          properties: {
            name: { type: :string , example: 'cpu'},
            start_date: { type: :string, format: 'date-time' , example: "2024-07-14T22:00:00.000Z"},
            end_date: { type: :string, format: 'date-time' , example: "2024-07-15T22:00:00.000Z"}
          },
          required: [ 'name', 'start_date', 'end_date' ]
        }

      response(200, 'successful') do
        schema type: :array, items: {
          type: :object,
          properties: {
            id: { type: :integer, example: 1 },
            name: { type: :string, example: 'cpu' },
            period: { type: :number, example: 0 },
            timestamp: { type: :string, format: :date_time, example: "2024-07-15T20:39:59.000Z" },
            average_value: { type: :number, format: :float, example: 45.05 },
            min_value: { type: :number, format: :float, example: 30 }, 
            max_value: { type: :number, format: :float, example: 60.1 }, 
            total_value: { type: :number, format: :float, example: 90.1 }, 
            count: { type: :number, example: 2 },
            created_at: { type: :string, format: :date_time, example: Time.now.iso8601 },
            updated_at: { type: :string, format: :date_time, example: Time.now.iso8601 },
          }
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

      response(422, 'invalid request') do
        schema type: :object,
          properties: {
            error: { type: :string, example: "Metric not found" }
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
        schema type: :object,
          properties: {
            error: { type: :string, example: "param is missing or the value is empty: start_date" }
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

  path '/metrics_aggregations/by_hour' do

    get('Fetch aggregated metrics by hour within a date range') do
      tags 'Aggregations'
      produces 'application/json'
      parameter name: :params, in: :query, 
      required: true,
      schema: {
          type: :object,
          properties: {
            name: { type: :string , example: 'cpu'},
            start_date: { type: :string, format: 'date-time' , example: "2024-07-14T22:00:00.000Z"},
            end_date: { type: :string, format: 'date-time' , example: "2024-07-15T22:00:00.000Z"}
          },
          required: [ 'name', 'start_date', 'end_date' ]
        }

      response(200, 'successful') do
        schema type: :array, items: {
          type: :object,
          properties: {
            id: { type: :integer, example: 1 },
            name: { type: :string, example: 'cpu' },
            period: { type: :number, example: 1 },
            timestamp: { type: :string, format: :date_time, example: "2024-07-15T20:59:59.000Z" },
            average_value: { type: :number, format: :float, example: 45.05 },
            min_value: { type: :number, format: :float, example: 30 }, 
            max_value: { type: :number, format: :float, example: 60.1 }, 
            total_value: { type: :number, format: :float, example: 90.1 }, 
            count: { type: :number, example: 2 },
            created_at: { type: :string, format: :date_time, example: Time.now.iso8601 },
            updated_at: { type: :string, format: :date_time, example: Time.now.iso8601 },
          }
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

      response(422, 'invalid request') do
        schema type: :object,
          properties: {
            error: { type: :string, example: "Metric not found" }
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
        schema type: :object,
          properties: {
            error: { type: :string, example: "param is missing or the value is empty: start_date" }
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

  path '/metrics_aggregations/by_day' do

    get('Fetch aggregated metrics by day within a date range') do
      tags 'Aggregations'
      produces 'application/json'
      parameter name: :params, in: :query, 
      required: true,
      schema: {
          type: :object,
          properties: {
            name: { type: :string , example: 'cpu'},
            start_date: { type: :string, format: 'date-time' , example: "2024-07-14T22:00:00.000Z"},
            end_date: { type: :string, format: 'date-time' , example: "2024-07-15T22:00:00.000Z"}
          },
          required: [ 'name', 'start_date', 'end_date' ]
        }

      response(200, 'successful') do
        schema type: :array, items: {
          type: :object,
          properties: {
            id: { type: :integer, example: 1 },
            name: { type: :string, example: 'cpu' },
            period: { type: :number, example: 2 },
            timestamp: { type: :string, format: :date_time, example: "2024-07-15T23:59:59.000Z" },
            average_value: { type: :number, format: :float, example: 45.05 },
            min_value: { type: :number, format: :float, example: 30 }, 
            max_value: { type: :number, format: :float, example: 60.1 }, 
            total_value: { type: :number, format: :float, example: 90.1 }, 
            count: { type: :number, example: 2 },
            created_at: { type: :string, format: :date_time, example: Time.now.iso8601 },
            updated_at: { type: :string, format: :date_time, example: Time.now.iso8601 },
          }
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

      response(422, 'invalid request') do
        schema type: :object,
          properties: {
            error: { type: :string, example: "Metric not found" }
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
        schema type: :object,
          properties: {
            error: { type: :string, example: "param is missing or the value is empty: start_date" }
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
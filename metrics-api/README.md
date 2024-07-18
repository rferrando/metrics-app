# README

## Getting started with Rails API
- This project was bootstrapped with [Create Rails API](https://guides.rubyonrails.org/api_app.html).
```sh
rails new metrics-api --api --database=postgresql --skip-git
```
- Create Dockerfile to start Rails server
- Create Docker compose to connect database to the server, so server accept connections when running locally

## Documenting Ruby on Rails APIs
To document your routes with OpenAPI in a Rails application, you can use the rswag gem. This tool integrates Swagger with Rails, allowing you to generate and maintain your API documentation efficiently.

Steps:
1. Add gems to Gemfile
```ruby
gem 'rspec-rails'
gem 'rswag'
```
1. Next, run the following commands:
```sh
bundle install
rails g rspec:install
rails g rswag:install
```

3. You should have the following files added to your repository, along with new routes added to the `routes.rb` file.
   - create  config/initializers/rswag_api.rb
   - add route  mount Rswag::Api::Engine => '/api-docs'
   - create  config/initializers/rswag_ui.rb
   - radd route  mount Rswag::Ui::Engine => '/api-docs'
   - create spec/swagger_helper.rb
   - create spec/rails_helper.rb
   - create spec/spec_helper.rb
4. Generate the swagger spec files within spec/requests for our controllers by running
```sh
rails generate rspec:swagger MetricsController
rails generate rspec:swagger MetricsAggregationsController
```
5. Generate the actual swagger docs that will be used for the swagger UI. Remember to create all necessary databases and run your pending migration.
```sh
rake rswag:specs:swaggerize
```
Note: It seems that as soon as rswag is loaded (uses Rspec), the Minitest function test and some others gets unset, leading to failure (cannot load test_helper.rb) when running the above command.So, before running the command rename test/test_helper.rb to test/test_helper.bk
6. Once successful you should have a `swagger.yaml` file, run your rails server rails s and go to the URL and add /api-docs and behold the Swagger UI documentation of all endpoints for the yours controller --> http://localhost:3000/api-docs

## Sequence Diagram
### Posting path

```mermaid
sequenceDiagram
   actor Sensor
   participant MetricsController
   participant MetricsRepository
   participant Database

   Sensor->>MetricsController: POST<br/>(name, value, timestamp)
   MetricsController->>MetricsRepository: create<br/>(name, value, timestamp)
   MetricsRepository->>MetricsRepository: enrich resolution data
   MetricsRepository->>Database: save
   Database-->>MetricsRepository: row inserted
   MetricsRepository-->>MetricsController: metric persisted
   MetricsController-->>Sensor: JSON<br/>(id, name, value, timestamp)
```
### Fetching path

```mermaid
sequenceDiagram
   actor Web
   participant MetricsAggregationsController
   participant MetricsAggregationRepository
   participant AggregationStateRepository
   participant MetricsAggregateService
   participant MetricsRepository
   participant Database

   Web->>MetricsAggregationsController: GET<br/>(name, period, start_date, end_date)
   MetricsAggregationsController->>MetricsAggregateService: call<br/>(name, period)

   MetricsAggregateService->>AggregationStateRepository: find_last_aggregated_at<br/>(name, period) -> start_time
   MetricsAggregateService->>MetricsRepository: maximum_time_registered_for_metric<br/>(name) -> end_time
   alt new metrics since last aggregation computed
         MetricsAggregateService->>MetricsRepository:calculate_aggregations_by_name_and_period_in_range<br/>(name, period, start_time, end_time) --> aggregate
         MetricsAggregateService->>MetricsAggregationRepository: upsert_all_aggregated_metric<br/>(aggregate)
         MetricsAggregationRepository->>Database: aggregated metric persisted
         MetricsAggregateService->>AggregationStateRepository: update_last_aggregated_at<br/>(name, period, end_time)
         AggregationStateRepository->>Database: last_aggregated_at updated 
   end
   
   MetricsAggregateService-->>MetricsAggregationsController: metric aggregate persisted
   MetricsAggregationsController->>MetricsAggregationRepository: find_by_name_and_period_and_date_range(name, period, start_date, end_date)
   MetricsAggregationRepository-->>MetricsAggregationsController: metric aggregate found
   MetricsAggregationsController-->>Web: JSON<br/>(id, name, period, timestamp, average_value, average_value, min_value, max_value, count)
```

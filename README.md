# Metrics App

## Overview
This application allows users to post and visualize metrics with a timestamp, name, and value. Metrics are shown on a timeline with averages per minute, hour, and day. The backend is built with Ruby on Rails and the frontend with React.

## Project structure

```yml
- metrics-api: Ruby on Rails API
    - app: 
        - controllers: contains application logic, performs validations and passing user input data to services or repositories
        - models: entities with just configuration and field declaration
        - repositories: layer for interaction with models and performing DB operations
        - services: The middleware between controller and repository. Gather data from controller, performs business logic, and calling repositories for data manipulation.
    - config: setting CORS, database related environment variables and configure the routes
    - db: definitions of database schema (migration files)
    - spec/swagger: specs to define endpoints with OpenAPI
    - test: tests for services, controllers, repositories and models
    - Gemfile: application dependencies
    - Dockerfile: docker definitions and scripts to build the required images
- metrics-client: React application
    - public: index.htmls as application entrypoint
    - src:
        - components: 
        - App: 
    - package.json: application dependencies
    - docker: docker definitions to build the required images
- Makefile: make definitions for building, test and local execution
```

## Prerequisites

### Docker Setup

- Docker
- Docker Compose

## How to run the Application

1. Clone the repository.
2. Navigate to the project root directory (metrics-app)
3. (Optional) Generate `package-lock.json` for the frontend:

   ```sh
   cd metrics-client
   npm install
   ```
4. Build and start the services:
   From the root directory of your project, execute:

   ```sh
   docker compose --profile dev up --build
   ```
5. Access the application:
- Rails API: http://localhost:3000
- React App: http://localhost:3001

This setup ensures that both the frontend and backend services run in their own containers, with dependencies managed by Docker, making it easier to develop and deploy the application consistently across different environments.

6. Stop the application:

   ```sh
   docker compose down
   ```
## How to run the test suite

1. Navigate to the root directory of your Rails application (/metrics-api)
2. (Optional) Make sure all necessary gems are installed:

   ```sh
   bundle install
   ```
3. You can run all the tests in the project with the following command. it make sure all migrations are up to date and
   the test database is configured correctly:

   ```sh
   docker compose --profile test up --build --exit-code-from metrics-api_test
   ```
4. After running the tests, the terminal will display the results, indicating how many tests passed and if there were
   any failures.

## How to generate random data

In order to have data to visualize once you start the application for the first time, an endpoint has been created to generate metrics randomly. To do this you must make a POST request to `/metrics/generate_random_data` indicating,
through the `num_metrics` parameter, the number of metrics to generate.

   ```sh
   curl -X POST http://localhost:3000/metrics/generate_random_data -d "num_metrics=100"
   ```

## Decisions and Trade-offs

- For the frontend **React**: Chosen for its component-based architecture and ease of creating interactive UIs.
- Building some **components** to:
  - `PostMetric`: simulate sending an event (a metric) from an application or sensor
  - `ViewMetric`: allow users to select the period (minute, hour or day) to visualize in a timeline chart the averages values of a selected metric according to the resolution time selected. A range of dates must be selected for which the time series of average values will be displayed. It is a first measure to prevent an endpoint from causing troubles, especially if the response exceeds the limits of the server or client, by allowing users to filter data before making the request to reduce the amount of data returned.
- Relying entirely on the Bootstrap stylesheet by importing `React-Bootstrap`
- For **posting and fetching data**: uses `axios` for making HTTP requests from React to the Rails API.
- To make **charts**, uses `react-chartjs-2` which is wrapper for `Chart.js` and `Luxon` to hadle time data.
As different metrics can have a range of values ​​with different orders of magnitude, a chart will be displayed with a Y axis adjusted to its scale and X axis adjusted to the period choosen.
- Errors Handling: An error alert is placed inside both components to show the HTTP code-based error handling being done from the rails application. In a productive environment, other approaches should be used that allow notifying the user in a more graceful way.
- Testing: only tested the classes with more complex logic (Metrics::Aggregate Service and MetricsAggregationsController)

- For the backend **Rails API**: Chosen for rapid development and ease of setting up an API with PostgreSQL. Building an API that third parties will be consuming and using JSON to serialize the data.
- Handling **Cross-Origin Resource Sharing (CORS)**: Configured to allow communication between the frontend and backend.
- Building some **endpoints** to:
  - `GET /metrics`: Fetch all metrics.
  - `GET /metrics_aggregations/by_minute`: Fetch aggregated metrics by minute.
  - `GET /metrics_aggregations/by_hour`: Fetch aggregated metrics y hour.
  - `GET /metrics_aggregations/by_day`: Fetch aggregated metrics by day.
- Documenting the endpoints with OpenAPI Specification by using gem `rswag`. This tool integrates Swagger with Rails, allowing you to generate and maintain your API documentation efficiently. After running rails server the URL http://localhost:3000/api-docs behold the Swagger UI documentation of all endpoints.
- **Data Aggregation**: In the case of our application, the aggregation functions are static (based on the timestamp),
so to efficiently compute the averages per minute/hour/day we use an approach based on a cache at database level, with incremental behavior, by not re-computing the partitions (name, period, timestamp) that have not changed.
- Applying **Service-Repository pattern** to have  more flexible, maintenable and testable application
- To centralize **error handling** in the Rails application, the app delegates on ApplicationController to handle errors and send a JSON with the message errors.Also a custom exception has been defined to handle 4XX errors during controllers validation.

## Data Model Design

In order to achieve this incremental behavior in the computation of the aggregation functions, we go from a data model with a single table where the metrics are persisted, and the wholse set of aggregation functions computation is performed with every query taking advantage of the capabilities of the database engine, to a more efficient data model with 3 different models:

- Metric: Stores raw data of each individual metric with its name, value and timestamp, enriched with information about time resolution.
- AggregatedMetric: Stores aggregations-related metric data for different periods/time resolution (hour, day, minute)
- AggregationState: Recors the date of the last aggregation for each period type and metric, to avoid re-computing
  periods that have already been processed.

 ```txt

+-----------------------------------------+
|     Metric                              |
+-----------------------------------------+
| id (PK)                                 |
| name                                    |
| value                                   |
| timestamp                               |
| created_at                              |
| updated_at                              |
+-----------------------------------------+
| *unique index: name, value, timestamp   |
| *index: name, created_at                |
| *index: name, minute_precision          |
| *index: name, hour_precision            |
| *index: name, day_precision             |
+-----------------------------------------+

        |
        |
        | has many
        |
        v

+----------------------+
|  AggregatedMetric    |
+----------------------+
| id (PK)              |
| name                 |
| period               |
| timestamp            |
| average_value        |
| min_value            |
| max_value            |
| total_value          |
| count                |
| created_at           |
| updated_at           |
+----------------------+
| *unique index:       |
| name, period,        |
| timestamp            |
+----------------------+

        |
        |
        | tracks
        |
        v

+----------------------+
|  AggregationState    |
+----------------------+
| id (PK)              |
| name                 |
| period               |
| last_aggregated_at   |
| created_at           |
| updated_at           |
+----------------------+
| *unique index:       |
| name, period         |
+----------------------+

 ```

The current version of the application is a simplification of a more real and more complex scenario in which we could receive a stream of data that would be processed in a data pipeline where the events would reach an intermediate queue with two different purposes, to be persisted in database and be consumed by a processor that would compute the metric aggregation functions on the fly, so that the query service would have this computation available in real time in a much more efficient way.

Below is an architecture diagram of the current scenario with respect to the scenario with the streaming approach:

![Architecture Diagram](/documentation/architecture-diagram.png)


The following sequence diagram reflects low-level details of both the current data ingestion path and the query path, showing how different application components interact with each other:

![Sequence Diagram - Ingestion path](/documentation/ingestion-path-sequence-diagram.png)

![Sequence Diagram - Query path](/documentation/query-path-sequence-diagram.png)

# Future Improvements

- **Handling large responses** effectively, it is important to implement strategies such as paging, filtering, data compression or batch processing. Additionally, checking client limits and handling errors appropriately will improve robustness and user experience.
- In a production environment, it is important to **handle and display errors** in a way that is clear and useful to users, without exposing unnecessary or sensitive technical details. Here are some approaches to improve error handling and reporting in web applications: non-intrusive notification messages, use a modal to display errors more prominently, use of application performance monitoring & error tracking.
- Full **testing coverage**: all controllers, repositories, models and services. Also all react components.
- The aggregation performance is good, but not very flexible, if we need to perform aggragation functions dynamically based on conditions such as a metric tag, we could look for other strategies such as using a cache at the API level, in which a request with the same parameters would return the cache information.
- Handling **secure endpoints** in the Rails application, ensuring that only authenticated and authorized users can access resources.
- Migrating the application to the streaming approach.
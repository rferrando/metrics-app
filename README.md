# Metrics App

## Overview
This application allows users to post and visualize metrics with a timestamp, name, and value. Metrics are shown on a timeline with averages per minute, hour, and day. The backend is built with Ruby on Rails and the frontend with React.

## Project Structure
- `metrics-api/`: Ruby on Rails API

### Getting Started with Create React App

This project was bootstrapped with [Create React App](https://github.com/facebook/create-react-app).
Run `npx create-react-app metrics-client`

- `metrics-client/`: React application

### Getting started with Rails API
This project was bootstrapped with [Create Rails API](https://guides.rubyonrails.org/api_app.html).
Run `rails new metrics-api --api --database=postgresql --skip-git`

## Running the Application

1. Clone the repository.
2. Navigate to the project root directory.
3. Build and start the services:
   From the root directory of your project, execute:

   ```sh
   docker-compose up --build
5. Stop the application:

   ```sh
   docker-compose down
5.Access the application:
- Rails API: http://localhost:3000
- React App: http://localhost:3001

This setup ensures that both the frontend and backend services run in their own containers, with dependencies managed by Docker, making it easier to develop and deploy the application consistently across different environments.

## Decisions and Trade-offs

- **Rails API**: Chosen for rapid development and ease of setting up an API with PostgreSQL.
- **React**: Chosen for its component-based architecture and ease of creating interactive UIs.
- **Data Fetching**: Used `axios` for making HTTP requests from React to the Rails API.
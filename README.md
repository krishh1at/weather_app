# Weather App

This application provides weather forecasts based on a given address.

## Prerequisites

- Ruby version: 3.4.1
- Rails version: 8.0.1
- System dependencies: Redis

## Setup

1. Clone the repository:
    ```sh
    git clone https://github.com/your-username/weather_app.git
    cd weather_app
    ```

2. Install dependencies:
    ```sh
    bundle install
    ```

3. Configure environment variables:
    - Create a `.env` file in the root directory.
    - Add your API keys and other environment variables to the `.env` file.

## Running the Application

1. Start the Redis server:
    ```sh
    redis-server
    ```

2. Start the Rails server:
    ```sh
    rails server
    ```

3. Access the application at `http://localhost:3000`.

## Running Tests

1. Run the test suite using RSpec:
    ```sh
    bundle exec rspec
    ```

## Services

- GeocoderService: Fetches latitude and longitude for a given address.
- WeatherService: Fetches weather data based on latitude and longitude.

## Deployment

1. Ensure all environment variables are set in the production environment.
2. Deploy the application using your preferred method (e.g., Heroku, AWS, etc.).

## Additional Information

For more details, refer to the official Rails documentation: [https://guides.rubyonrails.org/](https://guides.rubyonrails.org/)

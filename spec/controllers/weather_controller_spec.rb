require 'rails_helper'

RSpec.describe WeatherController, type: :controller do
  describe "GET #forecast" do
    let(:address) { "New York, NY" }
    let(:cache_key) { "weather_#{address}" }
    let(:lat_lng) { { lat: 40.7128, lng: -74.0060 } }
    let(:weather_data) do
      {
        "main" => { "temp" => 22.5, "temp_max" => 25.0, "temp_min" => 20.0 },
        "weather" => [{ "description" => "clear sky" }]
      }
    end

    let(:expected_response) do
      {
        temperature: 22.5,
        high: 25.0,
        low: 20.0,
        description: "clear sky"
      }
    end

    before do
      allow_any_instance_of(GeocoderService).to receive(:get_lat_lng).with(address).and_return(lat_lng)
      allow_any_instance_of(WeatherService).to receive(:fetch_weather).with(lat_lng[:lat], lat_lng[:lng]).and_return(weather_data)
    end

    context "when the request is valid" do
      it "returns the weather forecast data" do
        get :forecast, params: { address: address }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq(expected_response.stringify_keys)
      end

      it "caches the weather data" do
        expect(Rails.cache).to receive(:fetch).with(cache_key, expires_in: 30.minutes).and_call_original
        get :forecast, params: { address: address }
      end
    end

    context "when the request is cached" do
      before do
        Rails.cache.write(cache_key, expected_response)
      end

      it "returns cached data" do
        get :forecast, params: { address: address }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq(expected_response.stringify_keys)
      end
    end

    context "when the address is missing" do
      it "returns a bad request error" do
        get :forecast, params: {}
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)).to eq({ "error" => "Invalid address" })
      end
    end

    context "when the address is invalid" do
      before do
        allow_any_instance_of(GeocoderService).to receive(:get_lat_lng).with(address).and_return(nil)
      end

      it "returns a bad request error" do
        get :forecast, params: { address: address }
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)).to eq({ "error" => "Invalid address" })
      end
    end

    context "when weather data is missing" do
      before do
        allow_any_instance_of(WeatherService).to receive(:fetch_weather).and_return(nil)
      end

      it "returns a bad request error" do
        get :forecast, params: { address: address }
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)).to eq({ "error" => "Weather forecast not found" })
      end
    end
  end
end

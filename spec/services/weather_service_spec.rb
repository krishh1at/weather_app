require 'rails_helper'
require 'webmock/rspec'

RSpec.describe WeatherService do
  let(:weather_service) { described_class.new }
  let(:lat_lng)    { { lat: 40.7128, lng: -74.0060 } }

  describe "#fetch_weather" do
    context "lat, lng has an empty value" do
      it "returns nil if lng is nil" do
        expect(weather_service.fetch_weather(lat_lng[:lat], nil)).to be_nil
      end

      it "returns nil if lat is nil" do
        expect(weather_service.fetch_weather(nil, lat_lng[:lng])).to be_nil
      end

      it "returns nil if lat and lng both are nil" do
        expect(weather_service.fetch_weather(nil, nil)).to be_nil
      end
    end

    context "lat, lng has non-empty value" do
      let(:api_key)    { "test-api-key" }
      let(:weathe_url) { %r{https://api.openweathermap.org/data/2.5/weather.*} }

      before do
        allow(Rails.application.credentials).to receive(:open_wether).and_return(double(api_key: api_key))
      end

      context "api got failed" do
        it "returns nil when the API request fails" do
          stub_request(:get, weathe_url).to_return(status: 500, body: "", headers: {})
          expect(weather_service.fetch_weather(lat_lng[:lat], lat_lng[:lng])).to be_nil
        end
      end

      context "api got success" do
        before do
          stub_request(:get, weathe_url)
            .to_return(
              status: 200,
              body: {
                "coord": {
                  "lon": -0.1257,
                  "lat": 51.5085
                },
                "weather": [
                  {
                    "id": 800,
                    "main": "Clear",
                    "description": "clear sky",
                    "icon": "01d"
                  }
                ]
              }.to_json,
              headers: { 'Content-Type' => 'application/json' }
            )
        end

        it "returns a valid response" do
          expect(weather_service.fetch_weather(lat_lng[:lat], lat_lng[:lng])).not_to be_nil
        end
      end
    end
  end
end

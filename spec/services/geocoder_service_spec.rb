require 'rails_helper'
require 'webmock/rspec'

RSpec.describe GeocoderService do
  let(:geocoder) { described_class.new }

  describe "#get_lat_lng" do
    context "empty string as an address" do
      it "returns empty hash" do
        expect(geocoder.get_lat_lng("")).to eq({})
      end
    end

    context "not a empty string" do
      let(:api_key)     { "test-api-key" }
      let(:address)     { "New York" }
      let(:geocode_url) { %r{https://maps.googleapis.com/maps/api/geocode/json.*} }

      before do
        allow(Rails.application.credentials).to receive(:google).and_return(double(geocode_api_key: api_key))
      end

      context "api got failed" do
        it "returns nil when the API request fails" do
          stub_request(:get, geocode_url).to_return(status: 500, body: "", headers: {})
          expect(geocoder.get_lat_lng(address)).to eq({})
        end
      end

      context "api got success" do
        before do
          stub_request(:get, geocode_url)
            .to_return(
              status: 200,
              body: {
                results: [
                  {
                    geometry: {
                      location: {
                        lat: 40.7128,
                        lng: -74.0060
                      }
                    }
                  }
                ],
                status: "OK"
              }.to_json,
              headers: { 'Content-Type' => 'application/json' }
            )
        end

        it "returns a lat lang" do
          expect(geocoder.get_lat_lng(address)).to eq({
            "lat" => 40.7128,
            "lng" => -74.0060
          })
        end
      end
    end
  end
end

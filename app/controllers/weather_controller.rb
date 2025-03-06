class WeatherController < ApplicationController
  def forecast
    address = params[:address]
    return render_invalid_address if address.blank?

    forecast_data = Rails.cache.fetch(cache_key(address), expires_in: 30.minutes) do
      lat_lng = GeocoderService.new.get_lat_lng(address)
      return render_invalid_address if lat_lng.blank?

      weather = WeatherService.new.fetch_weather(lat_lng[:lat], lat_lng[:lng])
      return render_weather_not_found if weather.blank?

      extract_forecast_data(weather)
    end

    render json: forecast_data, status: :ok
  end

  private

  def cache_key(address)
    "weather_#{address}"
  end

  def render_invalid_address
    render json: { error: "Invalid address" }, status: :bad_request
  end

  def render_weather_not_found
    render json: { error: "Weather forecast not found" }, status: :bad_request
  end

  def extract_forecast_data(weather)
    {
      temperature: weather["main"]["temp"],
      high: weather["main"]["temp_max"],
      low: weather["main"]["temp_min"],
      description: weather["weather"].first["description"]
    }
  end
end

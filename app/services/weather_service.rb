class WeatherService
  BASE_URL = "https://api.openweathermap.org/data/2.5/weather".freeze

  def fetch_weather(lat, lng)
    return nil if lat.blank? || lng.blank?

    url = "#{BASE_URL}?lat=#{lat}&lon=#{lng}&units=metric&appid=#{ Rails.application.credentials.open_wether.api_key }"
    response = HTTParty.get(url)
    response.success? ? response.parsed_response : nil
  end
end

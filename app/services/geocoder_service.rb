class GeocoderService
  BASE_URL = "https://maps.googleapis.com/maps/api/geocode/json".freeze

  def get_lat_lng(address)
    return {} if address.blank?

    url = "#{ BASE_URL }?address=#{ address }&key=#{ Rails.application.credentials.google.geocode_api_key }"
    response = HTTParty.get(url)
    return {} unless response.success?

    response.with_indifferent_access.dig(:results, 0, :geometry, :location)
  end
end

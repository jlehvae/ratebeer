class BeermappingApi
  def self.places_in(city)
    city = city.downcase
    Rails.cache.fetch(city, expires_in: 1.week, race_condition_ttl: 1.minute) { fetch_places_in(city) }
  end

  def self.place_with_id(id)
    Rails.cache.fetch(id, expires_in: 1.week, race_condition_ttl: 1.minute) { fetch_place_with_id(id) }
  end

  private

  def self.fetch_places_in(city)
    url = "http://beermapping.com/webservice/loccity/#{key}/"

    response = HTTParty.get "#{url}#{ERB::Util.url_encode(city)}"
    places = response.parsed_response["bmp_locations"]["location"]

    return [] if places.is_a?(Hash) and places['id'].nil?

    places = [places] if places.is_a?(Hash)
    places.inject([]) do | set, place |
      set << Place.new(place)
    end
  end

  def self.fetch_place_with_id(id)
    url = "http://beermapping.com/webservice/locquery/#{key}/"

    response = HTTParty.get "#{url}#{ERB::Util.url_encode(id)}"
    return Place.new(response.parsed_response["bmp_locations"]["location"])
  end

  def self.key
    raise "RATEBEER_APIKEY env variable not defined" if ENV['RATEBEER_APIKEY'].nil?
    ENV['RATEBEER_APIKEY']
  end

end
class Place
  include ActiveModel::Model
  attr_accessor :id, :name, :status, :reviewlink, :proxylink, :blogmap, :street, :city, :state, :zip, :country, :phone, :overall, :imagecount

  def self.rendered_fields
    [:id, :name, :status, :street, :city, :zip, :country, :overall ]
  end

  def to_map_address_s
    ERB::Util.url_encode("#{street},#{city},#{country}")
  end

  def to_google_map_image_s
    "https://maps.googleapis.com/maps/api/staticmap?center=#{to_map_address_s}&zoom=14&size=400x400&markers=|#{to_map_address_s}"
  end
end
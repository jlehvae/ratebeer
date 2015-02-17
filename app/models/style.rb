class Style < ActiveRecord::Base
  include RatingAverage

  has_many :beers
  has_many :ratings, through: :beers

  def to_s
    name
  end

  def self.top(n)
    all.sort_by{ |b| -(b.average_rating||0) }.take(n)
  end
end

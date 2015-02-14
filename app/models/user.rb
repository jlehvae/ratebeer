class User < ActiveRecord::Base
  include RatingAverage

  has_secure_password

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships

  validates :username, uniqueness: true
  validates :username, length: {
                         minimum: 3,
                         maximum: 15
                     }
  validates :password, length: {
                         minimum: 4
                     }
  validates_format_of :password, with: /(?=.*[\d])/, message: "password must contain at least one digit"
  validates_format_of :password, with: /(?=.*[A-ZÅÄÖ])/, message: "password must contain at least one upper case letter"

  def favorite_beer
    return nil if ratings.empty?
    # ratings.sort_by{ |r| r.score }.last.beer
    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    return nil if ratings.empty?
    beers.group(:style).average(:score).max_by { |name, score| score }.first.name
  end

  def favorite_brewery
    return nil if ratings.empty?
    beers.group(:brewery).average(:score).max_by { |name, score| score }.first
  end

end

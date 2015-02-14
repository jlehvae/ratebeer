class Beer < ActiveRecord::Base
  include RatingAverage

  belongs_to :brewery
  belongs_to :style
  has_many :ratings, dependent: :destroy
  has_many :raters, through: :ratings, source: :user

  validates :name, presence: true, allow_blank: false

  def to_s
    return "#{self.name}, #{self.brewery.name}"
  end
end

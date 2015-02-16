class Brewery < ActiveRecord::Base
  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  include RatingAverage

  validates :name, presence: true, allow_blank: false
  validates :year, numericality: {
                     only_integer: true,
                     greater_than_or_equal_to: 1042
                 }

  validate :year_not_in_future

  scope :active, -> { where active: true }
  scope :retired, -> { where active: [nil,false] }

  def year_not_in_future
    if year > Time.now.year
      errors.add(:year, "year can not be in the future")
    end
  end

  def restart
    self.year = 2015
    puts "changed year to #{year}"
  end

  def print_report
    puts name
    puts "established at year #{year}"
    puts "number of beers #{beers.count}"
  end

end

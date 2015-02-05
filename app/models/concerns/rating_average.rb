module RatingAverage
  def average_rating
    self.ratings.average(:score)
  end
end
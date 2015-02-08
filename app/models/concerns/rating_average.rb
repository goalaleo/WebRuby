module RatingAverage

  extend ActiveSupport::Concern

  def average_rating
    ratings.inject(0.0) { |sum, i | sum + i.score  }/ratings.count
  end
end
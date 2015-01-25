class Beer < ActiveRecord::Base
  belongs_to :brewery
  has_many :ratings

  def average_rating
ratings.inject(0.0) { |sum, i | sum + i.score  }/ratings.count
end
  end

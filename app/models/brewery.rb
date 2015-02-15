class Brewery < ActiveRecord::Base
  include RatingAverage

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers


  validates :name, presence:  true
  validates :year, numericality: {greater_than_or_equal_to: 1042,
                                  only_integer: true}
  validate :year_less_than_current_year



  def year_less_than_current_year
    if year > Date.today.year
      errors.add(:year,"can't be greater than current year")
    end
  end

end
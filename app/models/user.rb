class User < ActiveRecord::Base
  include RatingAverage

  has_secure_password

  validates :username, uniqueness: true, length: {minimum: 3,
                                                  maximum: 15}
  validates :password, format: {with: /\A(?=.*\d)(?=.*[A-Z])\w{4,}\Z/,
                                message: "must have a minimum length of 4 characters,
and must contain at least 1 number and 1 uppercase character"}

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships
end

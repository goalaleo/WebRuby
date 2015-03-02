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

  def favorite_beer
    return nil if ratings.empty?
    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    return nil if ratings.empty?
    grouped_hash = group_ratings_by_style
    simplified_hash = only_styles_and_scores(grouped_hash)
    favorite = calculate_favorite_style(simplified_hash)
  end

  def favorite_brewery
    return nil if ratings.empty?
    grouped_hash = group_ratings_by_brewery
    simplified_hash = only_breweries_and_scores(grouped_hash)
    favorite = calculate_favorite_brewery(simplified_hash)
  end

  def group_ratings_by_brewery
    ratings.group_by { |r| r.beer.brewery.name }
  end


  def group_ratings_by_style
    ratings.group_by { |r| r.beer.style }
  end

  def only_styles_and_scores(styles_and_ratings)
    h = {}

    styles_and_ratings.each_pair do |style,list_of_ratings|
      h[style] = list_of_ratings.flat_map{|r| r.score }
    end

    h
  end

  def only_breweries_and_scores(breweries_and_ratings)
    h = {}

    breweries_and_ratings.each_pair do |brewery,list_of_ratings|
      h[brewery] = list_of_ratings.flat_map{|r| r.score }
    end

    h
  end

  def calculate_favorite_style(simplified_hash)
    h = {}
    simplified_hash.each_pair do|style,scores|
      h[style] = scores.inject{ |sum, score | sum + score }.to_f / scores.size
    end


    best_style = nil
    average_score = 0

    h.each_pair do |style, average|
      if average > average_score
        best_style = style
        average_score = average
      end
    end

    best_style
  end

  def calculate_favorite_brewery(simplified_hash)
    h = {}
    simplified_hash.each_pair do|brewery,scores|
      h[brewery] = scores.inject{ |sum, score | sum + score }.to_f / scores.size
    end


    best_brewery = nil
    average_score = 0

    h.each_pair do |brewery, average|
      if average > average_score
        best_brewery = brewery
        average_score = average
      end
    end

    best_brewery
  end


end




require 'rails_helper'

RSpec.describe User, type: :model do
  it "has the username set correctly" do
    user = User.new username:"Pekka"

    expect(user.username).to eq("Pekka")
  end

  it "is not saved without a password" do
    user = User.create username:"Pekka"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is not saved with a password that is too short" do
    user = User.create username:"Lyhyt", password:"Lh1", password_confirmation:"Lh1"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is not saved with a password that doesn't have a digit in it" do
    user = User.create username:"Nodigit", password:"Nodigit", password_confirmation:"Nodigit"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe "with a proper password" do
    let(:user){ FactoryGirl.create(:user) }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      user.ratings << FactoryGirl.create(:rating)
      user.ratings << FactoryGirl.create(:rating2)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end

  end

  describe "favorite beer" do
    let(:user){ FactoryGirl.create(:user) }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_beer)
    end

    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = FactoryGirl.create(:beer)
      rating = FactoryGirl.create(:rating, beer:beer, user:user)

      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      create_beer_with_rating(10, user)
      best = create_beer_with_rating(25, user)
      create_beer_with_rating(9, user)


      expect(user.favorite_beer).to eq(best)
    end
  end

  describe "favorite style" do
    let(:user){FactoryGirl.create(:user)}

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_style)
    end

    it "doesn't have one if user hasn't made any ratings" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is the style of the only beer rated by the user" do
      create_beer_with_rating(10,user)

      expect(user.favorite_style).to eq("Lager")
    end

    it "returns the correct style if there are multiple ratings, all for the same style" do
      create_beers_with_ratings(10, 20, user)

      expect(user.favorite_style).to eq("Lager")
    end

    it "returns the correct style if there are multiple ratings for multiple styles" do
      create_two_styles_with_ratings

      expect(user.favorite_style).to eq("Porter")
    end
  end

  describe "favorite brewery" do
    let(:user){FactoryGirl.create(:user)}

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_brewery)
    end

    it "doesn't have one if user hasn't made any ratings" do
      expect(user.favorite_brewery).to eq(nil)
    end

    it "is the brewery of the only beer rated by the user" do
      create_beer_with_rating(40, user)

      expect(user.favorite_brewery).to eq("anonymous")
    end

    it "is the better of two breweries rated by the user" do
      create_two_breweries_with_beers_and_ratings

      expect(user.favorite_brewery).to eq("Foobar")
    end
  end

end

def create_beer_with_rating(score, user)
  beer = FactoryGirl.create(:beer)
  FactoryGirl.create(:rating, score:score, beer:beer, user:user)
  beer
end

def create_beers_with_ratings(*scores, user)
  scores.each do |score|
    create_beer_with_rating(score, user)
  end
end

def create_two_styles_with_ratings
  beer1 = FactoryGirl.create(:beer)
  beer2 = FactoryGirl.create(:beer, style:"Porter")

  FactoryGirl.create(:rating, score:10, beer:beer1, user:user)
  FactoryGirl.create(:rating, score:30, beer:beer1, user:user)

  FactoryGirl.create(:rating, score:20, beer:beer2, user:user)
  FactoryGirl.create(:rating, score:25, beer:beer2, user:user)
end

def create_two_breweries_with_beers_and_ratings
  brewery1 = FactoryGirl.create(:brewery, name: "Hello world")
  brewery2 = FactoryGirl.create(:brewery, name: "Foobar")

  beer1 = FactoryGirl.create(:beer, brewery: brewery1)
  beer2 = FactoryGirl.create(:beer, brewery: brewery2)

  FactoryGirl.create(:rating, score: 5, beer: beer1, user: user)
  FactoryGirl.create(:rating, score: 6, beer: beer1, user: user)
  FactoryGirl.create(:rating, score: 7, beer: beer2, user: user)
  FactoryGirl.create(:rating, score: 8, beer: beer2, user: user)
end

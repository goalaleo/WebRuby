require 'rails_helper'

RSpec.describe Beer, type: :model do

  it "is saved when both name and style have been given" do
    beer = Beer.create name:"Leon olut", style:"Lager"

    expect(beer).to be_valid
    expect(Beer.count).to eq(1)
  end

  it "is not saved without a name" do
    beer = Beer.create style:"Lager"

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end

  it "is not saved without a style" do
    beer = Beer.create name:"Tyyliton"

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end

  describe "take in models and controllers" do
it "contains all of them" do
  BeerClubsController
  BeersController
  MembershipsController
end
  end


end

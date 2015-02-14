require 'rails_helper'

describe User do
  it "has the username set correctly" do
    user = User.new username:"Pekka"

    expect(user.username).to eq("Pekka")
  end

  it "is not saved without a password" do
    user = User.create username:"Pekka"

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

  describe "with invalid password" do
    it "is not saved" do
      user1 = User.create username:"Pekka", password:"secr", password_confirmation:"secr"
      user2 = User.create username:"Pekka", password:"secret", password_confirmation:"secret"

      expect(user1).to_not be_valid
      expect(user2).to_not be_valid
      expect(User.count).to eq(0)
    end
  end

  describe "favorite beer" do
    let(:user){FactoryGirl.create(:user) }

    it "has method for determining one" do
      expect(user).to respond_to :favorite_beer
    end

    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = create_beer_with_rating(10, user)

      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      create_beers_with_ratings(10, 20, 15, 7, 9, user)
      best = create_beer_with_rating(25, user)

      expect(user.favorite_beer).to eq(best)
    end
  end

  describe "favorite_style" do
    let(:user){FactoryGirl.create(:user) }
    let(:lager){FactoryGirl.create(:style)}
    let(:stout){FactoryGirl.create(:style, name: "stout")}
    let(:ipa){FactoryGirl.create(:style, name: "IPA")}

    it "has method for determining one" do
      expect(user).to respond_to :favorite_style
    end

    it "without ratings does not have one" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is the style if only one beer rated" do
      beer = create_beer_with_rating(10, user)

      expect(user.favorite_style).to eq(beer.style.name)
    end

    it "is the one with highest rating if several rated" do
      create_beers_with_ratings_and_style(10, 20, 15, 7, 1, user, stout)
      create_beers_with_ratings_and_style(10, 20, 15, 7, 9, user, ipa)
      create_beers_with_ratings_and_style(10, 20, 15, 7, 8, user, lager)

      expect(user.favorite_style).to eq('IPA')
    end
  end

  describe "favorite_brewery" do
    let(:user){FactoryGirl.create(:user) }

    it "has method for determining one" do
      expect(user).to respond_to :favorite_brewery
    end

    it "without ratings does not have one" do
      expect(user.favorite_brewery).to eq(nil)
    end

    it "is the brewery if only one beer rated from it" do
      brewery = FactoryGirl.create(:brewery, name:"koff")
      beer = create_beer_with_rating_and_brewery(10, user, brewery)

      expect(user.favorite_brewery).to eq(beer.brewery)
    end

    it "is the brewery if has the best average rating for it's beers" do
      b1 = FactoryGirl.create(:brewery, name:"koff")
      b2 = FactoryGirl.create(:brewery, name:"olvi")
      b3 = FactoryGirl.create(:brewery, name:"karjala")

      create_beers_with_ratings_and_brewery(10, 20, user, b1)
      create_beers_with_ratings_and_brewery(10, 30, user, b2)
      create_beers_with_ratings_and_brewery(10, 10, user, b3)

      expect(user.favorite_brewery).to eq(b2)
    end

  end

end # describe User

def create_beers_with_ratings_and_brewery(*scores, user, brewery)
  scores.each do |score|
    create_beer_with_rating_and_brewery score, user, brewery
  end
end

def create_beer_with_rating_and_brewery(score, user, brewery)
  beer = FactoryGirl.create(:beer, brewery: brewery)
  FactoryGirl.create(:rating, score:score, beer:beer, user:user)
  beer
end

def create_beers_with_ratings_and_style(*scores, user, style)
  scores.each do |score|
    create_beer_with_rating_and_style score, user, style
  end
end

def create_beer_with_rating_and_style(score, user, style)
  beer = FactoryGirl.create(:beer, style: style)
  FactoryGirl.create(:rating, score:score, beer:beer, user:user)
  beer
end

def create_beers_with_ratings(*scores, user)
  scores.each do |score|
    create_beer_with_rating score, user
  end
end

def create_beer_with_rating(score, user)
  beer = FactoryGirl.create(:beer)
  FactoryGirl.create(:rating, score:score, beer:beer, user:user)
  beer
end
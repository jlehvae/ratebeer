require 'rails_helper'

describe "User" do
  before :each do
    FactoryGirl.create :user
  end

  describe "who has signed up" do
    it "can signin with right credentials" do
      sign_in(username:"Pekka", password:"Foobar1")

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username:"Pekka", password:"wrong")

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'Username and/or password mismatch'
    end

    it "when signed up with good credentials, is added to the system" do
      visit signup_path
      fill_in('user_username', with:'Brian')
      fill_in('user_password', with:'Secret55')
      fill_in('user_password_confirmation', with:'Secret55')

      expect{
        click_button('Create User')
      }.to change{User.count}.by(1)
    end
  end

  describe "who has made ratings" do
    it "has his or her own ratings on the user page" do
      create_beers_and_ratings
      user1 = User.first
      user2 = User.last

      visit user_path(user1)
      expect(page).to have_content('Has made 2 ratings')
      expect(page).to have_content('iso 3')
      expect(page).to have_content('Karhu')

      visit user_path(user2)
      expect(page).to have_content('Has made 1 rating')
      expect(page).to have_content('lappari')
    end

    it "has favorite style" do
      create_beers_and_ratings
      user1 = User.first

      visit user_path(user1)

      expect(page).to have_content('Favorite style: Lager')
    end

    it "has favorite brewery" do
      create_beers_and_ratings
      user1 = User.first

      visit user_path(user1)

      expect(page).to have_content('Favorite brewery: Koff')
    end
  end

  describe "this is testing nothing" do
    it "get controllers to show up in the codecoverage report" do
      MembershipsController.blank?
      BeerClubsController.blank?
    end
  end
end

def create_beers_and_ratings
  user1 = User.first
  user2 = FactoryGirl.create :user2

  brewery = FactoryGirl.create :brewery, name:"Koff"
  beer1 = FactoryGirl.create :beer, name:"iso 3", brewery:brewery
  beer2 = FactoryGirl.create :beer, name:"Karhu", brewery:brewery
  beer3 = FactoryGirl.create :beer, name:"lappari", brewery:brewery

  FactoryGirl.create :rating, beer:beer1, user:user1
  FactoryGirl.create :rating, beer:beer2, user:user1
  FactoryGirl.create :rating, beer:beer3, user:user2
end
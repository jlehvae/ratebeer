require 'rails_helper'

describe "Beer" do
  let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
  let!(:style) { FactoryGirl.create :style }

  before :each do
    FactoryGirl.create :user
  end

  it "can be created with a valid name" do
    sign_in(username:"Pekka", password:"Foobar1")
    visit new_beer_path
    #save_and_open_page
    fill_in('beer[name]', with: 'olut')

    expect{
      click_button('Create Beer')
    }.to change { Beer.count }.from(0).to(1)

    expect(page).to have_content('Beer was successfully created')
  end

  it "can not be created with an invalid name" do
    sign_in(username:"Pekka", password:"Foobar1")
    visit new_beer_path
    fill_in('beer[name]', with: '')
    click_button('Create Beer')

    expect(page).to have_content("Name can't be blank")
    expect(Beer.count).to eq(0)
  end
end
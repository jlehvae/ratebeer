require 'rails_helper'

describe "Beer" do
  let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }

  it "can be created with a valid name" do
    visit new_beer_path
    fill_in('beer[name]', with: 'olut')

    expect{
      click_button('Create Beer')
    }.to change { Beer.count }.from(0).to(1)

    expect(page).to have_content('Beer was successfully created')
  end

  it "can not be created with an invalid name" do
    visit new_beer_path
    fill_in('beer[name]', with: '')
    click_button('Create Beer')

    expect(page).to have_content("Name can't be blank")
    expect(Beer.count).to eq(0)
  end
end
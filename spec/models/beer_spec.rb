require 'rails_helper'

RSpec.describe Beer, type: :model do

  it "can be saved with a style and a name" do
    beer = Beer.create name:"beer", style:"IPA"

    expect(beer).to be_valid
  end

  it "can not be saved without a name" do
    beer = Beer.create style:"IPA"

    expect(beer).not_to be_valid
  end

  it "can not be saved without a style" do
    beer = Beer.create name:"beer"

    expect(beer).not_to be_valid
  end

end

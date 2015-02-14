require 'rails_helper'

RSpec.describe Beer, type: :model do

  it "can be saved with a style and a name" do
    style = Style.create(name: "Lager", description: "description")
    beer = Beer.create name:"beer", style: style

    expect(beer).to be_valid
  end

  it "can not be saved without a name" do
    style = Style.create(name: "Lager", description: "description")
    beer = Beer.create style:style

    expect(beer).not_to be_valid
  end

  it "can not be saved without a style" do
    beer = Beer.create name:"beer"

    expect(beer).not_to be_valid
  end

end

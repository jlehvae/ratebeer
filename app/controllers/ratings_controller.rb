class RatingsController < ApplicationController
  def index
    @recent = Rating.recent.take 5
    @topBeers = Beer.top 3
    @topBreweries = Brewery.top 3
    @topStyles = Style.top 3
    @mostActiveRaters = User.most_active_raters 3
  end

  def new
    @rating = Rating.new
    @beers = Beer.all
  end

  def create
    @rating = Rating.new params.require(:rating).permit(:score, :beer_id)

    if current_user
      if @rating.save
        current_user.ratings << @rating
        redirect_to user_path current_user
      else
        @beers = Beer.all
        render :new
      end
    else
      @beers = Beer.all
      render :new
    end
  end

  def destroy
    rating = Rating.find params[:id]
    rating.delete if current_user == rating.user
    redirect_to :back
  end
end
class MembershipsController < ApplicationController
  before_action :set_membership, only: [:show, :edit, :update, :confirm_member] # , :destroy

  # GET /memberships
  # GET /memberships.json
  def index
    @memberships = Membership.all
  end

  # GET /memberships/1
  # GET /memberships/1.json
  def show
  end

  # GET /memberships/new
  def new
    @membership = Membership.new
    @beerclubs = BeerClub.all
  end

  # GET /memberships/1/edit
  def edit
  end

  def confirm_member
    @beerclub = BeerClub.find(@membership.beer_club_id)

    if @beerclub.is_member?(current_user)
      @membership.confirmed = true
      @membership.save
      redirect_to :back, notice: 'membership confirmed'
    end
  end

  # POST /memberships
  # POST /memberships.json
  def create
    @membership = Membership.new(membership_params)
    @membership.user = current_user

    respond_to do |format|
      if @membership.save
        flash[:notice] = "#{current_user.username}, welcome to the club!"
        format.html { redirect_to beer_club_path @membership.beer_club }
        format.json { render :show, status: :created, location: @membership }
      else
        @beerclubs = BeerClub.all
        format.html { render :new }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /memberships/1
  # PATCH/PUT /memberships/1.json
  def update
    respond_to do |format|
      if @membership.update(membership_params)
        format.html { redirect_to @membership, notice: 'Membership was successfully updated.' }
        format.json { render :show, status: :ok, location: @membership }
      else
        format.html { render :edit }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /memberships/1
  # DELETE /memberships/1.json
  def destroy
    @membership = current_user.memberships.find_by(beer_club_id: params[:membership][:beer_club_id])
    @membership.destroy
    respond_to do |format|
      format.html { redirect_to user_path(current_user), notice: "Membership in #{BeerClub.find_by(id: @membership.beer_club_id).name} beerclub ended" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_membership
      @membership = Membership.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def membership_params
      params.require(:membership).permit(:beer_club_id, :user_id)
    end
end

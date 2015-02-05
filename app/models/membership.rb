class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :beer_club

  validates_uniqueness_of :user_id, scope: :beer_club_id, message: "You are already a member"

end

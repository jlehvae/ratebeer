class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :beer_club

  scope :is_confirmed, -> { where confirmed: true }
  scope :is_applicant, -> { where confirmed: [nil, false] }

  validates_uniqueness_of :user_id, scope: :beer_club_id, message: "You are already a member"

end

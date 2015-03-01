class BeerClub < ActiveRecord::Base
  has_many :memberships
  has_many :users, through: :memberships

  def to_s
    "#{self.name}, #{self.city}"
  end

  def members
    memberships.is_confirmed.collect {|m| m.user}
  end

  def is_member?(user)
    members.include? user
  end
end

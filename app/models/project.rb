class Project < ActiveRecord::Base
  extend FriendlyId

  friendly_id :title, use: :slugged

  # Validate properties
  validates :title, :presence => true, :length => {:in => 3..255 }, :uniqueness => true,
            :format => { :with => /^([a-z \d]+)$/i, :message => "Only letters, numbers, and spaces are allowed." }
  validates :description, :length => { :maximum => 255 }

  # The user who owns this project
  belongs_to :owner, :class_name => "User"

  # Validate that an owner is defined for the project
  validates :owner_id, :presence => true

  # The users who can contribute to this project
  has_many :memberships, :dependent => :destroy
  has_many :members, :through => :memberships, :source => :user

  def is_member?(user)
    self.members.exists?(user)
  end

  def is_owner?(user)
    self.owner == user
  end
end

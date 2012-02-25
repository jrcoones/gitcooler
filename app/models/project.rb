class Project < ActiveRecord::Base
  extend FriendlyId

  friendly_id :title, use: :slugged

  # The users who can contribute to this project
  has_many :memberships, :dependent => :destroy
  has_many :members, :through => :memberships, :source => :user
end

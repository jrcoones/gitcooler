class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  # Link a user to projects they own
  has_many :my_projects, :dependent => :destroy, :class_name => "Project", :foreign_key => "owner_id"

  # Link a user to projects they are a member of
  has_many :memberships, :dependent => :destroy
  has_many :my_memberships, :through => :memberships, :source => :project

  # Projects this user is either a member of or a owner of...
  # TODO Refactor this later; I'm not sure this is very efficient
  def projects
    my_proj = self.my_projects
    my_memb = self.my_memberships
    my_proj + my_memb
  end

  # Link a user to keys they own
  has_many :keys, :dependent => :destroy, :autosave => true

  # Join first and last name
  def name
    "#{first_name} #{last_name}"
  end
end

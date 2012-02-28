class Key < ActiveRecord::Base

  # This key belongs to some user
  belongs_to :user

  # Validate that a user is defined for the key
  validates :user_id, :presence => true

  # Make sure the algorithm is always "ssh-rsa" or "ssh-dsa"
  before_validation :lowercase_algorithm
  validates :algorithm, :inclusion => { :in => %w(ssh-rsa ssh-dsa) }

  # Allow mass-assignment of algorithm, blob and name
  attr_accessible :algorithm, :blob, :name

  # Do not allow the algorithm, blob or name to be changed after creation
  attr_readonly :algorithm, :blob, :name

  # The Key must have a name; and it must be unique for a user
  validates :name, :uniqueness => { :scope => :user_id }, :length => { :in => 4..200 }

  def filename
    gitolite_key.filename
  end

  private
  def lowercase_algorithm
    self.algorithm.downcase!
  end

  def gitolite_key
    @gitolite_key ||= Gitolite::SSHKey.new(self.algorithm, self.blob, nil, snake_case(self.user.name), snake_case(self.name))
  end

  def snake_case(str)
    str.downcase.underscore.gsub(/\s/,"_").gsub(/\W/,"")
  end
end

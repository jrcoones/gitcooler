class GitProvider

  def self.user
    @@gitolite_user ||= YAML.load_file("#{Rails.root}/config/git_cooler.yml")["gitolite"]["user"]
  end

  def self.hostname
    @@gitolite_hostname ||= YAML.load_file("#{Rails.root}/config/git_cooler.yml")["gitolite"]["hostname"]
  end

  def self.port
    @@gitolite_port ||= YAML.load_file("#{Rails.root}/config/git_cooler.yml")["gitolite"]["port"]
  end

  # Provide the Path to the Git server manager (loaded from git_cooler.yml
  def self.path
    @@gitolite_repository_path ||= YAML.load_file("#{Rails.root}/config/git_cooler.yml")["gitolite"]["path"]
  end

  # Provides the base url that all of the sytem "clone" urls start from
  def self.base_clone_url(path)
    if self.port == 22
      "#{self.user}@#{self.hostname}:#{path}.git"
    else
      "ssh://#{self.user}@#{self.hostname}:#{self.port}/#{path}.git"
    end
  end

  # Provies the Git server manager
  def self.mngr
    @@gitolite_repository ||= Gitolite::GitoliteAdmin.new(self.path)
  end
end

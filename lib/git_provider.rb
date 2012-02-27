class GitProvider

  # Provide the Path to the Git server manager (loaded from git_cooler.yml
  def self.path
    @@gitolite_repository_path ||= YAML.load_file("#{Rails.root}/config/git_cooler.yml")["gitolite"]["path"]
  end

  # Provies the Git server manager
  def self.mngr
    @@gitolite_repository ||= Gitolite::GitoliteAdmin.new(self.path)
  end
end

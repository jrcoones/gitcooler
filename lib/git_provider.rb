class GitProvider

  # Provies the Git server manager
  def self.mngr
    @@gitolite_repository_path ||= YAML.load_file("#{Rails.root}/config/git_cooler.yml")["gitolite"]["path"]
    @@gitolite_repository ||= Gitolite::GitoliteAdmin.new(@@gitolite_repository_path)
  end
end

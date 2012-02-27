require 'spec_helper'
require 'net/ssh'

describe GitProvider do

  # TODO Refactor these...no need to keep reconnecting over and over again during the tests.
  def gitolite_username
    return Net::SSH.start(GitProvider.hostname, GitProvider.user, :port => GitProvider.port) do |ssh|
      result = ssh.exec!("info")
      is_gitolite_installed = /gitolite\sv(?<gitolite_version>[\w.-]+)/ =~ result
      /hello\s(?<gitolite_username>[\w.-]+)/ =~ result if is_gitolite_installed
      return gitolite_username
    end
  end

  # TODO Refactor these...no need to keep reconnecting over and over again during the tests.
  def gitolite_version
    return Net::SSH.start(GitProvider.hostname, GitProvider.user, :port => GitProvider.port) do |ssh|
      result = ssh.exec!("info")
      is_gitolite_installed = /gitolite\sv(?<gitolite_version>[\w.-]+)/ =~ result
      /hello\s(?<gitolite_username>[\w.-]+)/ =~ result if is_gitolite_installed
      return gitolite_version
    end
  end

  it { GitProvider.path.should == YAML.load_file("#{Rails.root}/config/git_cooler.yml")["gitolite"]["path"] }

  it { GitProvider.mngr.should be_instance_of(Gitolite::GitoliteAdmin) }
  it { expect { GitProvider.mngr }.to_not raise_error(Grit::InvalidGitRepositoryError) }
  it { expect { GitProvider.mngr }.to_not raise_error(Grit::NoSuchPathError) }
  it { expect { GitProvider.mngr }.to_not raise_error(Errno::ENOENT) }

  context "should have read/write permissions to everything" do
    before(:all) do
      path = File.join(GitProvider.path, "**/*")
      @all_files_and_dir = Dir.glob(path)
    end
    it { @all_files_and_dir.each { |file_or_dir| File.readable?(file_or_dir).should be_true } }
    it { @all_files_and_dir.each { |file_or_dir| File.writable?(file_or_dir).should be_true } }
  end

  context "check Gitolite server is configured correctly" do
    it { expect { gitolite_username }.to_not raise_error(Exception) }
    it { expect { gitolite_version }.to_not raise_error(Exception) }
    it { gitolite_username.should_not be_blank }
    it { gitolite_version.should_not be_blank }
  end
end

require 'spec_helper'

describe GitProvider do

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
end

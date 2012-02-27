require 'spec_helper'

describe GitProvider do
  it { GitProvider.mngr.should be_instance_of(Gitolite::GitoliteAdmin) }
  it { expect { GitProvider.mngr }.to_not raise_error(Grit::InvalidGitRepositoryError) }
  it { expect { GitProvider.mngr }.to_not raise_error(Grit::NoSuchPathError) }
  it { expect { GitProvider.mngr }.to_not raise_error(Errno::ENOENT) }
end

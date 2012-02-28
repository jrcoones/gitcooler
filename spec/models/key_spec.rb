require 'spec_helper'

describe Key do
  before do
    @current_user = Factory(:user, first_name: "Ryan", last_name: "Lovelett")
    @current_user.keys.create!(Factory.attributes_for(:key, user: nil, name: "Testing"))
  end

  context "must belong to a user" do
    it { expect { Factory(:key, user: nil) }.to raise_error(ActiveRecord::RecordInvalid) }
  end

  context "algorithm must be either ssh-dsa or ssh-rsa, will fix case" do
    it { expect { Factory(:key, algorithm: "ssh-dsa") }.to_not raise_error(ActiveRecord::RecordInvalid) }
    it { expect { Factory(:key, algorithm: "ssh-rsa") }.to_not raise_error(ActiveRecord::RecordInvalid) }
    it { expect { Factory(:key, algorithm: "sSh-Rsa") }.to_not raise_error(ActiveRecord::RecordInvalid) }
    it { expect { Factory(:key, algorithm: "git-coo") }.to raise_error(ActiveRecord::RecordInvalid) }
    it { Factory(:key, algorithm: "sSh-Rsa").algorithm.should == "ssh-rsa" }
  end

  context "destroying the user who owns the key destroys the key" do
    it { expect { @current_user.destroy }.to change(Key, :count).from(1).to(0) }
  end

  context "#filename" do
    before do
      @key = Factory(:key, name: "work", user: @current_user)
    end
    it { @key.filename.should == "ryan_lovelett@work.pub" }
  end

  context "is read-only after creation" do
    before { @key = Factory(:key) }
    it { expect { @key.update_attributes(algorithm: "ssh-dsa", blob: "keyssdfj", name: "The Moon"); @key.reload }.to_not change(@key, :algorithm) }
    it { expect { @key.update_attributes(algorithm: "ssh-dsa", blob: "keyssdfj", name: "The Moon"); @key.reload }.to_not change(@key, :blob) }
    it { expect { @key.update_attributes(algorithm: "ssh-dsa", blob: "keyssdfj", name: "The Moon"); @key.reload }.to_not change(@key, :name) }
  end

  context "name is unique for a user" do
    before do
      @another_user = Factory(:user)
    end
    it { expect { @current_user.keys.create!(Factory.attributes_for(:key, user:nil, name: "Testing")) }.to raise_error(ActiveRecord::RecordInvalid) }
    it { expect { @another_user.keys.create!(Factory.attributes_for(:key, user:nil, name: "Testing")) }.to_not raise_error(ActiveRecord::RecordInvalid) }
  end
end

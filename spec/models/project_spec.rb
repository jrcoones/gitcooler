require 'spec_helper'

describe Project do
  before { @current_user = Factory(:user) }

  context "title" do
    it "should only allow titles greater than 3, which only are letters, numbers and spaces" do
      invalid_titles = ["a", "ab", "ab^", "my-name-is-ryan", "This Should Not Be Valid!"]
      invalid_titles.each do |title|
        expect { Factory(:project, title: title ) }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    it { expect { Factory(:project, title: "This Should Be Valid" ) }.to_not raise_error(ActiveRecord::RecordInvalid) }
    it { expect { Factory(:project, title: "This 2 Should Be Valid" ) }.to_not raise_error(ActiveRecord::RecordInvalid) }
  end

  context "owner" do
    it { expect { Factory(:project_with_no_owner) }.to raise_error(ActiveRecord::RecordInvalid) }
  end

  context "members" do
    before { @project = Factory(:project, owner: @current_user) }
    it { expect { @project.members << 3.times.map { Factory(:user) } }.to change(@project.members, :size).from(0).to(3) }
  end

  context "is_member?, is_owner?" do
    before do
      @member = Factory(:user)
      @project = Factory(:project, owner: @current_user)
      @project.members << @member
    end
    it { @project.is_member?(@current_user).should be_false }
    it { @project.is_member?(@member).should be_true }
    it { @project.is_owner?(@current_user).should be_true }
    it { @project.is_owner?(@member).should be_false }
  end

  context "clone_url" do
    before { @project = Factory(:project) }
    it { @project.clone_url.should == "git@localhost:#{@project.slug}.git"}
  end

end

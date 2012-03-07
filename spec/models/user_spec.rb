require 'spec_helper'

describe User do
  before do
    # Create the current user
    @current_user = Factory(:user)

    # Create an additional user
    @another_user = Factory(:user)
  end

  context "#projects" do
    before do
      # Build projects the user owns
      3.times { @current_user.my_projects.create(Factory.attributes_for(:project)) }

      # Build projects the user belongs to
      2.times do |i|
        project = @another_user.my_projects.create(Factory.attributes_for(:project))
        project.members << @current_user unless i.odd?
      end
    end

    it { @current_user.projects.should have(4).items }
    it { @another_user.projects.should have(2).items }
    it { @current_user.my_projects.should have(3).items }
    it { @another_user.my_projects.should have(2).items }
    it { @current_user.collaborations.should have(1).items }
    it { @another_user.collaborations.should have(0).items }

    it { expect{ @current_user.destroy }.to change(Project, :count).from(5).to(2) }
    it { expect{ @current_user.destroy }.to change(@another_user.projects, :size).by(0) }
    it { expect{ @current_user.destroy }.to change(@another_user.my_projects, :size).by(0) }
    it { expect{ @current_user.destroy }.to change(@another_user.collaborations, :size).by(0) }

    it { expect{ @another_user.destroy }.to change(Project, :count).from(5).to(3) }
    it { expect{ @another_user.destroy }.to change(@current_user.projects, :size).from(4).to(3) }
    it { expect{ @another_user.destroy }.to change(@current_user.my_projects, :size).by(0) }
    it { expect{ @another_user.destroy }.to change(@current_user.collaborations, :size).from(1).to(0) }

  end

  context "#memberships" do
    before do
      # Create a project for the current user
      @current_user.my_projects.create(Factory.attributes_for(:project))

      # Build projects the user belongs to
      3.times do
        project = @another_user.my_projects.create(Factory.attributes_for(:project))
        project.members << @current_user
      end
    end

    it { expect{ @another_user.destroy }.to change(@current_user.collaborations, :size).from(3).to(0) }
    it { expect{ @another_user.destroy }.to change(Membership, :count).from(3).to(0) }
    it { expect{ @another_user.destroy }.to change(Project, :count).from(4).to(1) }
  end

  context "#keys" do
    before do
      # Create a key for the current user
      @key = @current_user.keys.create(Factory.attributes_for(:key))
      3.times { @current_user.keys.create(Factory.attributes_for(:key)) }
    end
    it { expect{ @key.destroy }.to change(@current_user.keys, :size).from(4).to(3) }
    it { @current_user.keys.size.should == 4 }
  end
end

require 'spec_helper'

describe User do
  context "#projects" do
    before do
      # Create the "me" user
      @current_user = Factory(:user)

      # Create the "someone else" user
      someone_else = Factory(:user)

      # Build projects the user owns
      3.times { @current_user.my_projects.create(Factory.attributes_for(:project)) }

      # Build projects the user belongs to
      2.times do |i|
        project = someone_else.my_projects.create(Factory.attributes_for(:project))
        project.members << @current_user unless i.odd?
      end
    end

    it { @current_user.projects.should have(4).items }
    it { @current_user.my_projects.should have(3).items }
    it { @current_user.my_memberships.should have(1).items }

  end

  context "#memberships" do
    before do
      # Create the current_user
      @current_user = Factory(:user)

      # Create someone else
      @someone_else = Factory(:user)

      # Build projects the user belongs to
      3.times do
        project = @someone_else.my_projects.create(Factory.attributes_for(:project))
        project.members << @current_user
      end
    end

    it { expect{ @someone_else.destroy }.to change(@current_user.my_memberships, :size).from(3).to(0) }
    it { expect{ @someone_else.destroy }.to change(Membership, :count).from(3).to(0) }
    it { expect{ @someone_else.destroy }.to change(Project, :count).from(4).to(1) }
  end
end

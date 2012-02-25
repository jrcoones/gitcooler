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
      1.times do
        project = someone_else.my_projects.create(Factory.attributes_for(:project))
        project.members << @current_user
      end
    end

    it { @current_user.projects.should have(4).items }
    it { @current_user.my_projects.should have(3).items }
    it { @current_user.my_memberships.should have(1).items }

  end
end

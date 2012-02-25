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
    end

    it { @current_user.my_projects.should have(3).items }

  end
end

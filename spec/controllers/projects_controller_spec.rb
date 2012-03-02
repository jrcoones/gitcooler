require 'spec_helper'

describe ProjectsController do

  # Since ProjectController extends ApiController; a user must be authenticated
  # to see any of the responses. Therfore, there are no tests for users being
  # logged in or not.

  let(:current_user) { Factory(:user) }

  # Create an log in the current user
  before(:each) do
    sign_in current_user, :user

    # Create a few projects for the user
    3.times { current_user.my_projects.create(Factory.attributes_for(:project, owner: nil)) }

    # Make sure the controller is using this actual user
    controller.stub!(:current_user).and_return(current_user)
  end

  context "GET 'index' as HTML" do
    before { get :index }
    it { response.should_not be_success }
    it { response.code.should eq("406") }
  end

  context "GET 'index'" do
    before do
      get :index, format: :json
    end
    it { response.should be_success }
    it { current_user.should_receive(:my_projects) }
  end

end

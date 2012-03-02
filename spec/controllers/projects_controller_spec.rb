require 'spec_helper'

describe ProjectsController do

  # Since ProjectController extends ApiController; a user must be authenticated
  # to see any of the responses. Therfore, there are no tests for users being
  # logged in or not.

  let(:current_user) { Factory(:user) }

  # Create an log in the current user
  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in current_user

    # Create a few projects for the user
    3.times { current_user.my_projects.create(Factory.attributes_for(:project, owner: nil)) }
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
    it { assigns(:projects).should have(3).items }
  end

end

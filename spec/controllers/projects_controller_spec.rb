require 'spec_helper'

describe ProjectsController do

  # Since ProjectController extends ApiController; a user must be authenticated
  # to see any of the responses. Therfore, there are no tests for users being
  # logged in or not.

  let(:current_user) { Factory(:user) }
  let(:current_user_project) { current_user.my_projects.create(Factory.attributes_for(:project, owner: nil)) }
  let(:another_user_project) { Factory(:project) }
  let(:project_attrs) { Factory.attributes_for(:project, owner: nil) }

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
    before { get :index, format: :json }
    it { response.should be_success }
    it { assigns(:projects).should have(3).items }
  end

  context "GET 'show'" do
    context "one of the current users projects" do
      before { get :show, format: :json, id: current_user_project }
      it { response.should be_success }
      it { assigns(:project).should == current_user_project }
    end
    context "a project that does not belong to the current user" do
      before { get :show, format: :json, id: another_user_project }
      it { response.should_not be_success }
      it { response.code.should eq("404") }
      it { response.body.should have_json_path("error/id") }
      it { response.body.should have_json_path("error/class_name") }
      it { response.body.should have_json_path("error/action_name") }
      it { response.body.should have_json_path("error/message") }
    end
  end

  context "PUT 'update'" do
    context "one of the current users projects" do
      before { put :update, format: :json, id: current_user_project, project: project_attrs }
      it { response.should be_success }
      it { assigns(:project).should be_a(Project) }
      it { assigns(:project).title.should == project_attrs[:title] }
      it { assigns(:project).should be_persisted }
      it { assigns(:project).slug.should_not == current_user_project.slug }
    end
    context "a project that does not belong to the current user" do
      before { put :update, format: :json, id: another_user_project, project: project_attrs }
      it { response.should_not be_success }
      it { response.code.should eq("404") }
      it { response.body.should have_json_path("error/id") }
      it { response.body.should have_json_path("error/class_name") }
      it { response.body.should have_json_path("error/action_name") }
      it { response.body.should have_json_path("error/message") }
    end
  end

  context "POST 'create'" do
    before { post :create, format: :json, project: project_attrs }
    it { response.should be_success }
    it { assigns(:project).should be_a(Project) }
    it { assigns(:project).should be_persisted }
    it { assigns(:project).title.should == project_attrs[:title] }
    it { assigns(:project).should be_valid }
  end

  context "DELETE 'destroy'" do
    context "one of the current users projects" do
      before { delete :destroy, format: :json, id: current_user_project }
      it { response.should be_success }
      it { expect { delete :destroy, format: :json, id: current_user_project }.to change(Project, :count).by(-1) }
    end
    context "a project that does not belong to the current user" do
      before { delete :destroy, format: :json, id: another_user_project }
      it { response.should_not be_success }
      it { response.code.should eq("404") }
      it { response.body.should have_json_path("error/id") }
      it { response.body.should have_json_path("error/class_name") }
      it { response.body.should have_json_path("error/action_name") }
      it { response.body.should have_json_path("error/message") }
    end
  end

end

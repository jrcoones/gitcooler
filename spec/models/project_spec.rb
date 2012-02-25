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
end

require 'spec_helper'

describe User do
  before { @user = FactoryGirl.create(:user) }
  subject { @user }

  it { should respond_to(:ip) }
  it { should respond_to(:blocked) }
  its(:blocked) { should == false }
  it { should be_valid }

  describe "when ip" do
    describe "is nil" do
      before { @user.ip = nil }
      it { should_not be_valid }
    end

    describe "is a unique IP string" do
      before { @user.ip = "1.1.1.1" }
      it { should be_valid }
    end

    describe "is a non-unique IP string" do
      before do
        FactoryGirl.create(:user, ip: "2.2.2.2")
        @user.ip = "2.2.2.2"
      end
      it { should_not be_valid }
    end
  end
end

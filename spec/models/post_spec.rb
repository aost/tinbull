require 'spec_helper'

describe Post do
  before { @post = FactoryGirl.build(:post) }
  subject { @post }

  it { should respond_to(:text) }
  it { should respond_to(:password_hash) }
  it { should be_valid }

  describe "when text" do
    describe "is blank" do
      before { @post.text = " " }
      it { should_not be_valid }
    end
  end

  describe "when password" do
    describe "is nil" do
      before { @post.password = nil }
      it { should be_valid }
      its(:password_hash) { should == nil }
    end

    describe "is a string" do
      before do
        @old_password_hash = @post.password_hash
        @post.password = "password1"
      end
      it { should be_valid }
      its(:password_hash) { should_not == @old_password_hash }
    end
  end
end

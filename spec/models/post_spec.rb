require 'spec_helper'

describe Post do
  before { @post = FactoryGirl.build(:post) }
  subject { @post }

  it { should respond_to(:text) }
  it { should respond_to(:password_hash) }
  it { should respond_to(:topic) }
  it { should respond_to(:parent) }
  it { should respond_to(:children) }
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

      describe "after saving" do
        before { @post.save }
        it { @post.topic.password_hashes.should include @post.password_hash }
      end
    end
  end

  describe "when topic" do
    describe "is nil" do
      before { @post.topic = nil }
      it { should_not be_valid }
    end

    describe "is a topic" do
      before { @post.topic = FactoryGirl.create(:topic) }
      it { should be_valid }
    end
  end

  describe "when parent" do
    describe "is nil" do
      before { @post.parent = nil }
      it { should be_valid }
    end

    describe "is a post" do
      before { @post.parent = FactoryGirl.create(:post) }
      it { should be_valid }
    end

    describe "is a topic" do
      it { expect { @post.parent = Topic.new }.to raise_error }
    end
  end
end

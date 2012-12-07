require 'spec_helper'

describe Topic do
  before { @topic = FactoryGirl.build(:topic) }

  subject { @topic }

  it { should respond_to(:name) }
  it { should respond_to(:text) }
  it { should respond_to(:created_at) }
  it { should respond_to(:updated_at) }
  it { should be_valid }

  describe "when name" do
    describe "is blank" do
      before { @topic.name = " " }
      it { should_not be_valid }
    end

    describe "is longer than 120 characters" do
      before { @topic.name = 'a'*121 }
      it { should_not be_valid }
    end
  end

  describe "when text" do
    describe "is blank" do
      before { @topic.text = " " }
      it { should be_valid }
    end

    describe "is over 5000 characters" do
      before { @topic.text = 'a'*5001 }
      it { should_not be_valid }
    end
  end
end

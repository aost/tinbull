require 'spec_helper'

describe Topic do
  before { @topic = FactoryGirl.build(:topic) }
  subject { @topic }

  it { should respond_to(:name) }
  it { should respond_to(:text) }
  it { should respond_to(:section) }
  it { should respond_to(:posts) }
  it { should respond_to(:password_hashes) }
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
    describe "is nil" do
      before { @topic.text = nil }
      it { should be_valid }
    end

    describe "is blank" do
      before { @topic.text = " " }
      its(:text) { should == nil }
    end

    describe "is over 5000 characters" do
      before { @topic.text = 'a'*5001 }
      it { should_not be_valid }
    end
  end

  describe "when section" do
    describe "is unspecified" do
      before { @topic.section = nil }
      it { should_not be_valid }
    end

    describe "is a section object" do
      before { @topic.section = FactoryGirl.create(:section) }
      it { should be_valid }
    end

    describe "is the name of an existing section" do
      before do
        FactoryGirl.create(:section, name: 'science')
        @topic.section = 'science'
      end
      it { should be_valid }
    end

    describe "is the name of a nonexistent section" do
      before { @topic.section = 'newsection' }
      it { should be_valid }
    end
  end

  describe "when password_hashes" do
    describe "is called" do
      before { @ph = @topic.password_hashes }
      it { @ph.should be_a_kind_of Array }
    end
  end

  describe "when passworded post is added" do
    before do
      @topic.posts << FactoryGirl.create(:post, password: 'loafly')
    end
    it { should be_valid }
    its(:password_hashes) { should have(1).hashstring }
    it { @topic.posts[0].poster_id.should == 'A' }

    describe "and two more with the same password" do
      before do
        2.times do
          @topic.posts << FactoryGirl.create(:post, password: 'loafly')
        end
      end
      it { should be_valid }
      its(:password_hashes) { should have(1).hashstring }
      it { 2.times { |i| @topic.posts[i].poster_id.should == 'A' } }
    end

    describe "and twenty-seven more with different passwords" do
      before do
        27.times do |i|
          @topic.posts << FactoryGirl.create(:post, password: (1+i).to_s)
        end
      end
      it { should be_valid }
      its(:password_hashes) { should have(28).hashstrings }
      it do
        {1 => 'B', 2 => 'C', 3 => 'D'}.each do |k, v|
          @topic.posts[k].poster_id.should == v
        end
      end
      it do
        {25 => 'Z', 26 => 'AA', 27 => 'AB'}.each do |k, v|
          @topic.posts[k].poster_id.should == v
        end
      end
    end

    describe "and two more without passwords" do
      before do
        2.times { @topic.posts << FactoryGirl.create(:post) }
      end
      it { should be_valid }
      its(:password_hashes) { should have(1).hashstring }
      it { 2.times { |i| @topic.posts[1+i].poster_id.should == nil } }
    end
  end

end

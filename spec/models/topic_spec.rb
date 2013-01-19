require 'spec_helper'

describe Topic do
  before { @topic = FactoryGirl.create(:topic) }
  subject { @topic }

  it { should respond_to(:name) }
  it { should respond_to(:section) }
  it { should respond_to(:posts) }
  it { should respond_to(:password_hashes) }
  it { should respond_to(:sub_id) }
  it { should respond_to(:popularity) }
  it { should respond_to(:created_at) }
  it { should respond_to(:updated_at) }
  it { should be_valid }

  describe "when name" do
    describe "is blank" do
      before { @topic.name = " " }
      it { should_not be_valid }
    end

    describe "is a string" do
      before { @topic.name = "Thoughts on Super Gear Escape 2" }
      it { should be_valid }
    end

    describe "is longer than 120 characters" do
      before { @topic.name = 'a'*121 }
      it { should_not be_valid }
    end
  end

  describe "when section" do
    describe "is blank" do
      before { @topic.section = ' ' }
      it { should_not be_valid }
    end

    describe "is a short lowercase string" do
      before { @topic.section = 'videogames' }
      it { should be_valid }
    end

    describe "is longer than 20 characters" do
      before { @topic.section = 'a'*21 }
      it { should_not be_valid }
    end

    describe "contains digits" do
      before { @topic.section = '42nouns' }
      it { should be_valid }
    end

    describe "contains non-alphanumeric characters" do
      before { @topic.section = 'foo_bar' }
      it { should_not be_valid }
    end

    describe "contains capital letters" do
      before { @topic.section = 'fooBar' }
      its(:section) { should == 'foobar' }
    end

    describe "starts with a squiggly" do
      before { @topic.section = '~somesection' }
      its(:section) { should == 'somesection' }
    end
  end

  describe "when posts" do
    describe "has 0 items" do
      before { @topic.posts.clear }
      it { should be_valid }
      its(:popularity) { should == 0 }
    end

    describe "has 1 item" do
      before do
        @topic.posts << FactoryGirl.create(:post, topic: @topic)
        @topic.save
        @topic.reload
      end
      it { should be_valid }
      its(:popularity) { should_not == 0 }

      it "should autosave with topic" do
        @topic.name = "Hello!"
        @topic.posts[0].text = "How are you!"
        @topic.save
        @topic.posts[0].changed?.should == false
      end

      it "should be destroyed with the topic" do
        post_id = @topic.posts[0].id
        @topic.destroy
        Post.where(id: 8).should be_empty
      end

      it "should touch the topic"
    end
  end

  describe "when password_hashes" do
    describe "is called" do
      before { @ph = @topic.password_hashes }
      it { @ph.should be_a_kind_of Array }
    end
  end

  describe "with a passworded post" do
    before do
      @topic.posts.clear
      @topic.posts << FactoryGirl.build(:post, topic: @topic, password: 'loafly')
      @topic.posts[0].save!
      @topic.reload
    end
    it { should be_valid }
    its(:password_hashes) { should have(1).hashstring }
    it { @topic.posts[0].password_id.should == 'A' }

    describe "and two more with the same password" do
      before do
        2.times do
          @topic.posts << FactoryGirl.create(:post, topic: @topic, password: 'loafly')
        end
      end
      it { should be_valid }
      its(:password_hashes) { should have(1).hashstring }
      it { 2.times { |i| @topic.posts[i].password_id.should == 'A' } }
    end

    describe "and twenty-seven more with different passwords" do
      before do
        27.times do |i|
          @topic.posts << FactoryGirl.create(:post, topic: @topic, password: (1+i).to_s)
        end
        @topic.reload
      end
      it { should be_valid }
      its(:password_hashes) { should have(28).hashstrings }
      it do
        {1 => 'B', 2 => 'C', 3 => 'D'}.each do |k, v|
          @topic.posts.order('id ASC')[k].password_id.should == v
        end
      end
      it do
        {25 => 'Z', 26 => 'AA', 27 => 'AB'}.each do |k, v|
          @topic.posts.order('id ASC')[k].password_id.should == v
        end
      end

      describe "and there's another topic with a passworded post" do
        before do
          @topic2 = FactoryGirl.create(:topic)
          @topic2.posts[0].password = "yo"
          @topic2.save
        end
        
        its(:password_hashes) { should have(28).hashstrings }
      end
    end

    describe "and two more without passwords" do
      before do
        2.times { @topic.posts << FactoryGirl.create(:post) }
      end
      it { should be_valid }
      its(:password_hashes) { should have(1).hashstring }
      it { 2.times { |i| @topic.posts[1+i].password_id.should == nil } }
    end
  end

  describe "when there is another topic" do
    describe "in the same section" do
      before { @topic2 = FactoryGirl.create(:topic, section: @topic.section) }
      its(:sub_id) { should == 1 }
      it { @topic2.sub_id.should == 2 }
    end

    describe "in a different section" do
      before { @topic2 = FactoryGirl.create(:topic, section: 'other') }
      its(:sub_id) { should == 1 }
      it { @topic2.sub_id.should == 1 }
    end
  end

end

require 'spec_helper'

describe "Post pages" do
  subject { page }

  describe "new" do
    before do
      @topic = FactoryGirl.create :topic
      @topic.posts.clear
      @parent = @topic.posts.create(text: "I'm running out of filler ideas.",
        password: "noimagination", poster: FactoryGirl.create(:user))
      visit new_post_path(@parent.topic.section, @parent.topic.sub_id, @parent.sub_id)
    end

    it { should have_selector('title', text: "filler") }
    it { should have_selector('div', text: @parent.text) }
    it { should have_selector('p', text: @parent.password_id) }
    it { should have_selector('p', text: time_ago_in_words(@parent.created_at)) }

    describe "with a blocked IP" do
    end

    describe "with text filled" do
      before do
        fill_in "Text", with: "Russell Brand did what?"
      end

      it "should create a post" do
        expect { click_button "Reply" }.to change(Post, :count).by(1)
      end

      describe "after submitting" do
        before { click_button "Reply" }
        let(:post) { Post.last }

        it "should redirect to the topic with the post" do
          current_path.should == topic_path(@topic.section, @topic.sub_id) 
          page.should have_selector('div', text: post.text)
        end

        it { post.poster.ip.should == "127.0.0.1" }
      end

      describe "after submitting with blocked IP" do
        before do
          @user = 
            User.where(ip: "127.0.0.1").first || User.create(ip: "127.0.0.1")
          @user.blocked = true
          @user.save
          click_button "Reply"
        end

        it "should rerender the form with an error" do
          page.should have_selector('form')
          page.should have_selector('ul[id="error"]')
        end
      end
    end
    
    describe "with text not filled" do
      it "should not create a topic" do
        expect { click_button "Reply" }.to change(Post, :count).by(0)
      end

      describe "after submitting" do
        before { click_button "Reply" }

        it "should rerender the form with errors" do
          page.should have_selector('form')
          page.should have_selector('ul[id="error"]')
        end
      end
    end
  end

  describe "flag" do
    before do
      @topic = FactoryGirl.create :topic
      @topic.posts.clear
      @post = @topic.posts.create(text: "I'm running out of filler ideas.",
        password: "noimagination", poster: FactoryGirl.create(:user))
      visit flag_post_path(@post.topic.section, @post.topic.sub_id, @post.sub_id)
    end

    it "should rerender topic" do
      current_path.should == topic_path(@topic.section, @topic.sub_id) 
    end

    it "should add flagger to post" do
      @post.flaggers.count.should == 1
    end

    it "should have a flagged post" do
      page.should have_selector('a[class="flagged"]')
    end
  end
end

require 'spec_helper'

describe "Topic pages" do
  subject { page }

  describe "index" do
    before { visit topics_path }

    it { should have_selector('title', text: "Tin Bull") }

    describe "with 26 topics" do
      before do
        FactoryGirl.create(:topic, name: "I'm different!", section: 'unique')
        25.times { FactoryGirl.create :topic }
        visit topics_path
      end

      it "should have an element for each topic" do
        Topic.paginate(page: 1).each do |topic|
          page.should have_selector('li p', text: topic.posts.length.to_s)
          page.should have_selector('li a', text: topic.name)
          page.should have_selector('li a', text: topic.section)
          page.should have_selector('li p', 
            text: time_ago_in_words(topic.updated_at))
          page.should have_selector('li p', 
            text: time_ago_in_words(topic.created_at))
        end
      end

      it "should have a link to the second page" do
        page.should have_selector('div a', text: 2.to_s)
      end
        
    end

    describe "with 1 topic" do
      before do
        @topic = FactoryGirl.create(:topic)
      end

      describe "when topic" do
        describe "has 0 posts" do
          before { visit topics_path }

          it { should have_selector('li p', text: '0') }
          it "should not have a time range" do
            page.should_not have_selector('li p', text: "\u2013")
          end
        end

        describe "has 1 post" do
          before do 
            @topic.posts << FactoryGirl.create(:post, topic: @topic)
            visit topics_path
          end

          it { should have_selector('li p', text: '1') }
          it "should have a time range" do
            page.should have_selector('li p', text: "\u2013")
          end
        end
      end
    end
  end
end

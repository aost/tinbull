require 'spec_helper'

describe "Topic pages" do
  subject { page }

  describe "index" do
    before do
      FactoryGirl.create(:topic, name: "I'm different!", section: 'unique')
      30.times { FactoryGirl.create :topic }
      visit topics_path
    end

    it { should have_selector('title', text: "Tin Bull") }

    it "should have an element for each topic" do
      Topic.paginate(page: 1).each do |topic|
        page.should have_selector('li p', text: topic.posts.length.to_s)
        page.should have_selector('li a', text: topic.name)
        page.should have_selector('li a', text: topic.section)
        page.should have_selector('li p', 
          text: time_ago_in_words(topic.created_at))
        page.should have_selector('li p', 
          text: time_ago_in_words(topic.updated_at))
      end
    end
  end
end

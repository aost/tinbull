require 'spec_helper'

describe "Post pages" do
  subject { page }

  describe "new" do
    before do
      topic = FactoryGirl.create :topic
      topic.posts.clear
      @parent = topic.posts.create(text: "I'm running out of filler ideas.",
        password: "noimagination", poster: FactoryGirl.create(:user))
      visit new_post_path(@parent.topic.section, @parent.topic.sub_id, @parent.sub_id)
    end

    it { should have_selector('title', text: "filler") }
    it { should have_selector('div', text: @parent.text) }
    it { should have_selector('p', text: @parent.password_id) }
    it { should have_selector('p', text: time_ago_in_words(@parent.created_at)) }

  end
end

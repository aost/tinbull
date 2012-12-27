require 'spec_helper'

describe "Topic pages" do
  subject { page }

  describe "index" do
    before { visit topics_path }

    it { should have_selector('title', text: "Tin Bull") }

    it "should be able to respond with JSON and XML" do
      visit topics_path(format: :json)
      page.response_headers['Content-Type'].should include 'application/json'
      visit topics_path(format: :xml)
      page.response_headers['Content-Type'].should include 'application/xml'
    end

    describe "in a section with a topic" do
      before do
        FactoryGirl.create(:topic, name: "Hello!", section: 'hello')
        visit topics_path('hello')
      end

      it { should have_selector('title', text: "~hello") }
      it { should have_selector('#section', text: "~hello") }
      it { should_not have_selector('#topics li', text: "~hello") }
    end

    describe "with 26 topics" do
      before do
        25.times { FactoryGirl.create :topic }
        FactoryGirl.create(:topic, name: "I'm different!", section: 'unique')
        visit topics_path
      end

      it "should have an element for each topic" do
        Topic.page(1).each do |topic|
          page.should have_selector('li div', text: (topic.posts.length-1).to_s)
          page.should have_selector('li a[class="topic-title"]', text: topic.name)
          page.should have_selector('li a', text: topic.section)
          page.should have_selector('li p', 
            text: time_ago_in_words(topic.updated_at))
          page.should have_selector('li p', 
            text: time_ago_in_words(topic.created_at))
        end
      end

      it "should have a link to the next page" do
        page.should have_selector('a', text: "Next")
      end

    end

    describe "with 1 topic" do
      before do
        @topic = FactoryGirl.create(:topic)
      end

      describe "when topic" do
        describe "has 1 post" do
          before { visit topics_path }

          it { should have_selector('li div', text: '0') }

          it "should not have a time range" do
            page.should_not have_selector('li p', text: "\u2013")
          end
        end

        describe "has 2 posts" do
          before do 
            @topic.posts << FactoryGirl.create(:post, topic: @topic)
            visit topics_path
          end

          it { should have_selector('li div', text: '1') }
          it "should have a time range"
        end
      end

      describe "with section" do
        before { visit topics_path('arbitrary') }

        it { should have_selector('title', text: "~arbitrary | Tin Bull") }
        it { should have_selector('div a', text: "~arbitrary") }
      end
    end
  end


  describe "show" do
    before do
      @topic = FactoryGirl.create(:topic, name: "What is this fish?", 
                                          section: 'marinebiology')
      @topic.posts[0].text = "It looks almost like it's not a fish."
      @topic.posts[0].password = "mlh"
      @topic.save!
      visit topic_path(section: 'marinebiology', id: 1)
    end

    it { should have_selector('title', text: "this fish") }
    it { should have_selector('h1', text: "this fish") }
    it { should have_selector('a', text: "~marinebiology") }
    it { should have_selector('p', text: "not a fish") }
    it { should have_selector('p', text: "A") }
    it { should have_selector('p', text: time_ago_in_words(@topic.created_at)) }
    it { should have_selector('a', text: "Reply") }
    it { should have_selector('a', text: "\u2691") } # Flag

    it "should be able to respond with JSON and XML" do
      visit topic_path(section: 'marinebiology', id: 1, format: :json)
      page.response_headers['Content-Type'].should include 'application/json'
      visit topic_path(section: 'marinebiology', id: 1, format: :xml)
      page.response_headers['Content-Type'].should include 'application/xml'
    end

    describe "with a reply" do
      before do
        @reply = @topic.posts.create(text: "I don't know.", password: "124")
        visit topic_path(section: 'marinebiology', id: 1)
      end

      it { should have_selector('p', text: "I don't know.") }
      it { should have_selector('p', text: "B") }
      it { should have_selector('a', text: "Reply", count: 2) }
      it { should have_selector('a', text: "\u2691", count: 2) }

      describe "and a reply to that reply" do
        before do
          @topic.posts.create(text: "Ohoho", password: "124", parent: @reply)
          visit topic_path(section: 'marinebiology', id: 1)
        end

        it { should have_selector('p', text: "Ohoho", count: 1) }
        it { should have_selector('p', text: "B", count: 2) }
      end
    end
  end

  describe "new" do
    before { visit new_topic_path }
    
    it { should have_selector('title', text: "New topic | Tin Bull") }
    it { should have_selector('form') }
    it { should have_selector("input[id='topic_name']") }
    it { should have_selector("input[id='topic_section']") }
    it { should have_selector("textarea[id='topic_posts_attributes_0_text']") }
    it { should have_selector("input[id='topic_posts_attributes_0_password']") }
  end
end

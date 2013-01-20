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
          page.should have_selector('li a[class="name"]', text: topic.name)
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
            @topic.posts << FactoryGirl.create(:post, topic: @topic, created_at: 5.minutes.from_now)
            visit topics_path
          end

          it { should have_selector('li div', text: '1') }
          it { should have_selector('p', text: "\u2013") } # en dash, for time range
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
      @topic.posts.clear
      @topic.posts << FactoryGirl.create(:post, 
                        text: "It looks almost like it's not a fish.",
                        password: "mlh", topic: @topic)
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
        @reply = @topic.posts.create(text: "I don't know.", password: "124",
          poster: FactoryGirl.create(:user))
        visit topic_path(section: 'marinebiology', id: 1)
      end

      it { should have_selector('p', text: "I don't know.") }
      it { should have_selector('p', text: "B") }
      it { should have_selector('a', text: "Reply", count: 2) }
      it { should have_selector('a', text: "\u2691", count: 2) }

      describe "and a reply to that reply" do
        before do
          @topic.posts.create(text: "Ohoho", password: "124", parent: @reply,
            poster: FactoryGirl.create(:user))
          visit topic_path(section: 'marinebiology', id: 1)
        end

        it { should have_selector('p', text: "Ohoho", count: 1) }
        it { should have_selector('p', text: "B", count: 2) }
      end
    end

    describe "with nonexistent topic" do
      before { visit topic_path(section: 'null', id: 1) }

      it { should have_selector('h1', text: "404") }
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

    describe "with valid information" do
      before do
        fill_in "Section", with: "cake"
        fill_in "Topic", with: "<topic here>"
        fill_in "Text", with: "References make the world go 'round."
        fill_in "Password", with: "secret"
      end

      it "should create a topic" do
        expect { click_button "Create topic" }.to change(Topic, :count).by(1)
      end

      describe "after submitting" do
        before { click_button "Create topic" }
        let(:topic) { Topic.last }
      
        it "should render the topic" do
          current_path.should == topic_path(topic.section, topic.sub_id) 
          page.should have_selector('title', text: topic.name)
          page.should have_selector('div', text: topic.posts[0].text)
        end

        it "should log IP" do
          topic.posts[0].poster.ip.should == "127.0.0.1"
        end
      end
    end
    
    describe "with blank information" do
      it "should not create a topic" do
        expect { click_button "Create topic" }.to change(Topic, :count).by(0)
      end

      describe "after submitting" do
        before { click_button "Create topic" }

        it "should rerender the form with errors" do
          page.should have_selector('form')
          page.should have_selector('ul[id="error"]')
        end
      end
    end

    describe "within a section" do
      before { visit new_topic_path('yay') }
      it { should have_selector('input[id="topic_section"][value="yay"]') }
    end
  end
end

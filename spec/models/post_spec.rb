require 'spec_helper'

describe Post do
  before { @post = FactoryGirl.build(:post) }
  subject { @post }

  it { should respond_to(:text) }
  it { should respond_to(:password_hash) }
  it { should respond_to(:password_id) }
  it { should respond_to(:topic) }
  it { should respond_to(:sub_id) }
  it { should respond_to(:parent) }
  it { should respond_to(:children) }
  it { should respond_to(:poster) }
  it { should_not respond_to(:ip) }
  it { should be_valid }

  describe "when text" do
    describe "is blank" do
      before { @post.text = " " }
      it { should_not be_valid }
    end

    describe "is a string" do
      before { @post.text = "String!" }
      it { should be_valid }
    end

    describe "is a string with over 5000 characters" do
      before { @post.text = 'a'*5001 }
      it { should_not be_valid }
    end

    describe "is a string with HTML" do
      it "should be escaped" do
        @post.text = "<script>alert('haha, i hack you')</script>"
        @post.html.should == "<p>&lt;script&gt;alert(&#x27;haha, i hack you&#x27;)&lt;/script&gt;</p>"
      end
    end

    describe "is a string with markup" do
      it "should wrap in at least one p tag" do
        @post.text = "I am technically a paragraph."
        @post.html.should == "<p>I am technically a paragraph.</p>"
        @post.plain_text.should == @post.text
      end

      it "should italicize" do
        @post.text = "*So* ignorant."
        @post.html.should == "<p><i>So</i> ignorant.</p>"
        @post.plain_text.should == "So ignorant."
      end

      it "should embolden" do
        @post.text = "You are **wrong**."
        @post.html.should == "<p>You are <b>wrong</b>.</p>"
        @post.plain_text.should == "You are wrong."
      end

      it "should italicize and embolden" do
        @post.text = "You *dare defy **your creator!?!***"
        @post.html.should == "<p>You <i>dare defy <b>your creator!?!</b></i></p>"
        @post.plain_text.should == "You dare defy your creator!?!"
      end

      it "should make named links" do
        @post.text = "Click [here|http://shocking.com/gasp/] instead."
        @post.html.should == 
          '<p>Click <a href="http://shocking.com/gasp/">here</a> instead.</p>'
        @post.plain_text.should == "Click here instead."

        @post.text = "[Pills here!|spam.com]"
        @post.html.should == '<p><a href="http://spam.com">Pills here!</a></p>'
        @post.plain_text.should == "Pills here!"

        @post.text = "[This section is nice.|/~heartwarmingnews]"
        @post.html.should == 
          '<p><a href="/~heartwarmingnews">This section is nice.</a></p>'
        @post.plain_text.should == "This section is nice."
      end

      it "should make unnamed links" do
        @post.text = "Feeling down? Try http://scenemusic.net, it's neato."
        @post.html.should == "<p>Feeling down? Try <a href=\"http://scenemusic.net\">http://scenemusic.net</a>, it&#x27;s neato.</p>"
        @post.plain_text.should == @post.text
      end

      it "should make ordered lists" do
        @post.text = "1. Is this a list?\n2. I think so!\n33. Yep."
        @post.html.should == "<ol><li value=\"1\">Is this a list?</li>\n<li value=\"2\">I think so!</li>\n<li value=\"33\">Yep.</li></ol>"
        # TODO: @post.plain_text.should == @post.text

        @post.text = "I have $20. You can't have it."
        @post.html.should == "<p>I have $20. You can&#x27;t have it.</p>"
        @post.plain_text.should == @post.text
      end

      it "should make unordered lists" do
        @post.text = "* Oh look...\n* Another list!"
        @post.html.should == "<ul><li>Oh look...</li>\n<li>Another list!</li></ul>"
        # TODO: @post.plain_text.should == @post.text

        @post.text = "I will sneak in a list * bwahaha!"
        @post.html.should == "<p>I will sneak in a list * bwahaha!</p>"
        @post.plain_text.should == @post.text
      end

      it "should seperate paragraphs" do
        @post.text = "one paragraph.\n\ntwo paragraph!\nstill two paragraph.\n\nthree paragraph."
        @post.html.should == "<p>one paragraph.</p><p>two paragraph!\nstill two paragraph.</p><p>three paragraph.</p>"
      end

      it "shouldn't affect the original text" do
        @post.text = "Hello!"
        html = @post.html
        @post.text.should_not == html
      end
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

      describe "after saving and reloading" do
        before { @post.save; @post.reload }
        it { @post.topic.password_hashes.should include @post.password_hash }
        its(:password_id) { should == 'A' }
      end

      describe "with over 128 characters" do
        before do
          @post.password = '?'*129
        end
        it { should_not be_valid }
      end
    end

    describe "is an empty string" do
      before { @post.password = "" }
      it { should be_valid }
      its(:password_hash) { should == nil }
    end
  end

  describe "when topic" do
    describe "is nil" do
      before { @post.topic = nil }
      #it { should_not be_valid } TODO: Add topic form doesn't work with this 
      it "should not be valid"
    end

    describe "is a topic" do
      before do
        @post.build_topic(name: "Yeah!", section: 'optimism')
        @post.topic.posts << @post
        @post.save
        @post.reload
      end

      it { should be_valid }
      its(:sub_id) { should == 0 }

      it "should touch the topic on post save" do
        @post.topic.should_receive :touch
        @post.save
      end
    end
  end

  describe "when parent" do
    describe "is nil" do
      before { @post.parent = nil }
      it { should be_valid }
    end

    describe "is a post" do
      before { @post.parent = FactoryGirl.create(:post); @post.save }
      it { should be_valid }
      its(:topic) { should == @post.parent.topic }
    end

    describe "is a topic" do
      it { expect { @post.parent = Topic.new }.to raise_error }
    end
  end

  describe "when poster" do
    describe "is nil" do
      before { @post.poster = nil }
      it { should_not be_valid }
    end

    describe "is a User" do
      before { @post.poster = FactoryGirl.create(:user) }
      it { should be_valid }
    end
  end
end

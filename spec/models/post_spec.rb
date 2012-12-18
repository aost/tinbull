require 'spec_helper'

describe Post do
  before { @post = FactoryGirl.build(:post) }
  subject { @post }

  it { should respond_to(:text) }
  it { should respond_to(:password_hash) }
  it { should respond_to(:poster_id) }
  it { should respond_to(:topic) }
  it { should respond_to(:parent) }
  it { should respond_to(:children) }
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

    describe "is a string with markup" do
      it "should wrap in at least one p tag" do
        @post.text = "I am technically a paragraph."
        @post.text.should == "<p>I am technically a paragraph.</p>"
      end

      it "should italicize" do
        @post.text = "/So/ ignorant."
        @post.text.should == "<p><i>So</i> ignorant.</p>"
      end

      it "should embolden" do
        @post.text = "You are *wrong*."
        @post.text.should == "<p>You are <b>wrong</b>.</p>"
      end

      it "should underline" do
        @post.text = "Click _here_. Haha, gotcha."
        @post.text.should == "<p>Click <u>here</u>. Haha, gotcha.</p>"
      end

      it "should make links" do
        @post.text = "Click [here|http://shocking.com] instead."
        @post.text.should == 
          '<p>Click <a href="http://shocking.com">here</a> instead.</p>'
      end

      it "should make ordered lists" do
        @post.text = "1. Is this a list?\n2. I think so!\n33. Yep."
        @post.text.should == "<p><ol><li value=\"1\">Is this a list?</li>\n<li value=\"2\">I think so!</li>\n<li value=\"33\">Yep.</li></ol></p>"
      end

      it "should make unordered lists" do
        @post.text = "* Oh look...\n* Another list!"
        @post.text.should == "<p><ul><li>Oh look...</li>\n<li>Another list!</li></ul></p>"
      end

      it "should make monospace text" do
        @post.text = "  destroy_all_who_oppose(self)\n  return !prisoners"
        @post.text.should == 
          "<p><pre>destroy_all_who_oppose(self)</pre>\n<pre>return !prisoners</pre></p>"
      end

      it "should seperate paragraphs" do
        @post.text = "one paragraph.\n\ntwo paragraph!\nstill two paragraph."
        @post.text.should == "<p>one paragraph</p>\n\n<p>two paragraph!\nstill two paragraph</p>"
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

      describe "after saving" do
        before { @post.save }
        it { @post.topic.password_hashes.should include @post.password_hash }
        its(:poster_id) { should == 'A' }
      end
    end
  end

  describe "when topic" do
    describe "is nil" do
      before { @post.topic = nil }
      it { should_not be_valid }
    end

    describe "is a topic" do
      before { @post.topic = FactoryGirl.create(:topic) }
      it { should be_valid }
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
      before { @post.parent = FactoryGirl.create(:post) }
      it { should be_valid }
    end

    describe "is a topic" do
      it { expect { @post.parent = Topic.new }.to raise_error }
    end
  end
end

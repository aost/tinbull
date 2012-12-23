require 'spec_helper'

describe Post do
  before { @post = FactoryGirl.build(:post) }
  subject { @post }

  it { should respond_to(:text) }
  it { should respond_to(:password_hash) }
  it { should respond_to(:poster_id) }
  it { should respond_to(:topic) }
  it { should respond_to(:sub_id) }
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

    describe "is a string with over 5000 characters" do
      before { @post.text = 'a'*5001 }
      it { should_not be_valid }
    end

    describe "is a string with markup" do
      it "should wrap in at least one p tag" do
        @post.text = "I am technically a paragraph."
        @post.html.should == "<p>I am technically a paragraph.</p>"
      end

      it "should italicize" do
        @post.text = "/So/ ignorant."
        @post.html.should == "<p><i>So</i> ignorant.</p>"
      end

      it "should embolden" do
        @post.text = "You are *wrong*."
        @post.html.should == "<p>You are <b>wrong</b>.</p>"
      end

      it "should make named links" do
        @post.text = "Click [here|http://shocking.com/gasp/] instead."
        @post.html.should == 
          '<p>Click <a href="http://shocking.com/gasp/">here</a> instead.</p>'
      end

      it "should make unnamed links" do
        @post.text = "Feeling down? Try http://scenemusic.net, it's neato."
        @post.html.should == "<p>Feeling down? Try <a href=\"http://scenemusic.net\">http://scenemusic.net</a>, it's neato.</p>"
      end

      it "should make ordered lists" do
        @post.text = "1. Is this a list?\n2. I think so!\n33. Yep."
        @post.html.should == "<p><ol><li value=\"1\">Is this a list?</li>\n<li value=\"2\">I think so!</li>\n<li value=\"33\">Yep.</li></ol></p>"
      end

      it "should make unordered lists" do
        @post.text = "* Oh look...\n* Another list!"
        @post.html.should == "<p><ul><li>Oh look...</li>\n<li>Another list!</li></ul></p>"
      end

      it "should make monospace text" do
        @post.text = "  destroy_all_who_oppose(self)\n  return !prisoners"
        @post.html.should == 
          "<p><pre>destroy_all_who_oppose(self)</pre>\n<pre>return !prisoners</pre></p>"
      end

      it "should seperate paragraphs" do
        @post.text = "one paragraph.\n\ntwo paragraph!\nstill two paragraph.\n\nthree paragraph."
        @post.html.should == "<p>one paragraph.</p><p>two paragraph!\nstill two paragraph.</p><p>three paragraph.</p>"
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
        its(:poster_id) { should == 'A' }
      end

      describe "with over 128 characters" do
        before do
          @post.password = '?'*129
        end
        it { should_not be_valid }
      end
    end
  end

  describe "when topic" do
    describe "is nil" do
      before { @post.topic = nil }
      #it { should_not be_valid } TODO: Add topic form doesn't work with this 
      it "should not be valid"
    end

    describe "is a topic" do
      before { @post.topic = FactoryGirl.create(:topic); @post.save; @post.reload }
      it { should be_valid }
      its(:sub_id) { should == 1 } # second post sub_id

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
end

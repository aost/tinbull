require 'spec_helper'

describe "Special pages" do
  subject { page }

  describe "sections" do
    before { visit sections_path }
    it { should have_selector('title', text: "Sections") }
    it { should have_selector('h1', text: "Sections") }

    describe "with three topics" do
      before do
        FactoryGirl.create(:topic, section: 'alpha')
        2.times { FactoryGirl.create(:topic, section: 'dos') }
        3.times { FactoryGirl.create(:topic, section: 'charlie') }
        visit sections_path
      end

      it { should have_selector('a', text: 'alpha', count: 1) }
      it { should have_selector('a', text: 'dos', count: 1) }
      it { should have_selector('a', text: 'charlie', count: 1) }
    end
  end

  describe "about" do
    before { visit about_path }
    it { should have_selector('title', text: "About") }
    it { should have_selector('h1', text: "About") }
  end

  describe "markup" do
    before { visit markup_path }
    it { should have_selector('title', text: "Markup") }
    it { should have_selector('h1', text: "Markup") }
  end

  describe "code" do
    before { visit code_path }
    it "should redirect to github repo"
  end
end

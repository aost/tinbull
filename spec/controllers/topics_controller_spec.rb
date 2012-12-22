require 'spec_helper'

describe TopicsController do
  describe "POST create" do
    context "with valid attributes" do
      it "creates a new topic"
        #expect {
        #  post :create, topic: FactoryGirl.attributes_for(:topic) TODO: Fix this test
        #}.to change(Topic, :count).by(1)
      #end

      it "redirects to new topic" #do
        #post :create, topic: FactoryGirl.attributes_for(:topic)
        #response.should redirect_to Topic.last # TODO: Fix this one too
      #end
    end
  end
end

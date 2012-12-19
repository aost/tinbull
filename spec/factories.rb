FactoryGirl.define do 
  factory :topic do
    name "What is a man?"
    section 'philosophy'
    before(:create) do |topic|
      topic.posts << FactoryGirl.build(:post, topic: topic)
    end
  end

  factory :post do
    text "A miserable pile of secrets!"
    topic
  end
end

FactoryGirl.define do 
  factory :topic do
    name "What is a man?"
    section 'philosophy'
  end

  factory :post do
    text "A miserable little pile of secrets!"
    topic
    association :poster, factory: :user
  end

  factory :user do
    sequence(:ip) { |n| "127.0.0.#{n}" }
  end
end

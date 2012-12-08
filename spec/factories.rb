FactoryGirl.define do 
  sequence(:foobarn) { |n| "foobar#{n}" }

  factory :section do
    name { generate(:foobarn) }
  end

  factory :topic do
    name "What is a man?"
    section
  end

  factory :post do
    text "A miserable pile of secrets!"
    topic
  end
end

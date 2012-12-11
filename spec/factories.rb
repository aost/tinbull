FactoryGirl.define do 
  factory :topic do
    name "What is a man?"
    section 'philosophy'
  end

  factory :post do
    text "A miserable pile of secrets!"
    topic
  end
end

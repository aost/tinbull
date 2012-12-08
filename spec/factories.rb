FactoryGirl.define do 
  factory :section do
    name 'foobar'
  end

  factory :topic do
    name "What is a man?"
    section
  end

  factory :post do
    text "A miserable pile of secrets!"
  end
end

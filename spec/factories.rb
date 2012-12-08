FactoryGirl.define do 
  factory :section do
    name 'foobar'
  end

  factory :topic do
    name "What is a man?"
    text "I wonder."
    section
  end

  factory :post do
    text "A miserable pile of secrets!"
    password "1234"
  end
end

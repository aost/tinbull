Tinbull::Application.routes.draw do
  match '(~:section)' => 'topics#index', as: :topics, via: :get
  match '(~:section)/new' => 'topics#new', as: :new_topic
  match '~:section/:id' => 'topics#show', as: :topic
  match '(~:section)' => 'topics#create', as: :topics, via: :post
end

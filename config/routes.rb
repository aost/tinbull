Tinbull::Application.routes.draw do
  match '(~:section)' => 'topics#index', as: :topics, via: :get
  match '~:section/:id' => 'topics#show', as: :topic
  match '(~:section)/new' => 'topics#new', as: :new_topic
  match '(~:section)' => 'topics#create', as: :topics, via: :post

  match '~:section/:topic_id/:parent_id/reply' => 'posts#new', as: :new_post
  match '~:section/:topic_id/:parent_id' => 'posts#create', as: :posts, via: :post

  match '~' => 'special#sections', as: :sections
  match 'about' => 'special#about', as: :about
  match 'markup' => 'special#markup', as: :markup
  match 'code' => 'special#code', as: :code
end

Tinbull::Application.routes.draw do
  match '(~:section)' => 'topics#index', as: :topics, via: :get
  match '(~:section)/new' => 'topics#new', as: :new_topic
  match '~:section/:id' => 'topics#show', as: :topic
  match '(~:section)' => 'topics#create', as: :topics, via: :post

  match '~:section/:topic_id/:parent_id' => 'posts#create', as: :posts, via: :post
  match '~:section/:topic_id/:parent_id/reply' => 'posts#new', as: :new_post
  match '~:section/:topic_id/:post_id/flag' => 'posts#flag', as: :flag_post

  match '~' => 'special#sections', as: :sections
  match 'about' => 'special#about', as: :about
  match 'markup' => 'special#markup', as: :markup
  match 'code' => 'special#code', as: :code
  match '*nonsense' => 'application#render_missing_page', as: :not_found
end

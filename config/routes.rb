Tinbull::Application.routes.draw do
  match '/(~:section)' => 'topics#index', as: :topics
  match '/~:section/:id' => 'topics#show', as: :topic
end

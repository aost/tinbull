Tinbull::Application.routes.draw do
  root to: 'topics#index', as: :topics
  #match "~" => "sections#index", as: :sections
end

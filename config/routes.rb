Rails.application.routes.draw do

  get 'game', to: 'game_engine#game'
  get 'score', to: 'game_engine#score'

  root to: 'game_engine#game'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

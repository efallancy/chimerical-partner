Rails.application.routes.draw do

  root 'pages#chime'

  get '/commands' => 'pages#commands'
  get '/fetch_initial_weather' => 'pages#fetch_initial_weather'
  get '/fetch_news' => 'pages#fetch_news'
  get '/fetch_quote' => 'pages#fetch_quote'
  get '/fetch_featured_playlist' => 'pages#fetch_featured_playlist'

end

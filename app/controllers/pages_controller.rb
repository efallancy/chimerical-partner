class PagesController < ApplicationController
  def maintenance
  end

  def chime
    @initial_state = init
  end

  def commands
    # Get parameter value for user message
    # command = params[ "user_message" ]

  end

  def fetch_initial_weather
    response = { "error": "Position not specified" }
    # Only if the lat & lng parameter is being specified, therefore return weather state
    if params[ "lat" ] != "" && params[ "lng" ] != ""
     response = get_current_weather( params[ "lat" ], params[ "lng" ] )
    end

    render json: response
  end

  private

    def init
      initial = { "quote": get_quote }

      # Return initial as json
      initial
    end

    def get_quote
      url = "http://quotesondesign.com/wp-json/posts?filter[orderby]=rand&filter[posts_per_page]=1&callback="
      options = { cache: false }
      response = HTTParty.get( url, :query => options )
      quote = { "author": response.first[ "title" ], "content": response.first[ "content" ] }

      # Return quote
      quote
    end

    # This will include the current requested weather and also forecast of the next day
    def get_current_weather( lat, lng )
      url = "https://api.darksky.net/forecast/#{ Rails.application.secrets.DARK_SKY_SECRET }/" + lat + "," + lng;
      options = { exclude: "[minutesly,hourly]", units: "auto" }

      response = HTTParty.get( url, :query => options )

      currently = {
                    "summary": response[ "currently" ][ "summary" ],
                    "last_updated": Time.at( response[ "currently" ][ "time" ] ).strftime( "%a, %b %d, %H:%M" ),
                    "icon": response[ "currently" ][ "icon" ],
                    "temperature": response[ "currently" ][ "temperature" ]
                  }

      tomorrow = response[ "daily" ][ "data" ][ 1 ]
      tomorrow_weather = {
                            "summary": tomorrow[ "summary" ],
                            "icon": tomorrow[ "icon" ],
                            "min_temperature": tomorrow[ "temperatureMin" ],
                            "max_temperature": tomorrow[ "temperatureMax" ]
                         }

      weather_summary = { "currently": currently, "tomorrow": tomorrow_weather }

      # Return weather summary
      weather_summary
    end

    # NYTimes results based on the category specified.
    #  Default is home
    def get_news
    end

    # Spotify playlist
    def get_spotify_playlist
      # Using terminal to execure the GET/POST request
    end



end

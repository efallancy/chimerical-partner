class PagesController < ApplicationController
  def maintenance
  end

  def wit
  end

  # This will be the controller for defining the API request to be made
  def demand
    if params[ "q" ]
      response = get_wit( params[ "q" ] )

      render json: response
    else
      render json: { "error": "No input received" }
    end

  end

  private
    # GET request from Wit
    def get_wit( q )
      wit_access_token = Rails.application.secrets.WIT_AI_CLIENT_ACCESS_TOKEN
      question = q
      wit_url = "https://api.wit.ai/message"

      url = "#{ wit_url }?access_token=#{ wit_access_token }&q=#{ question }"

      response = HTTParty.get( url )

      if response
        if response[ "entities" ][ "intent" ] && response[ "entities" ][ "intent" ].first[ "value" ] === "get_weather"
          return get_weather( response )
        end
      end

      # Return response
      response
    end

    # GET request for weather
    def get_weather( response )
      dark_sky_secret = Rails.application.secrets.DARK_SKY_SECRET
      weather_url = "https://api.darksky.net/forecast/#{ dark_sky_secret }"

      # Use geocoder to get the lat and lng value coordinates
      location = response[ "entities" ][ "location" ].first[ "value" ]
      result = Geocoder.search( location )

      lat = result.first.data[ "geometry" ][ "location" ][ "lat" ]
      lng = result.first.data[ "geometry" ][ "location" ][ "lng" ]

      # Include the si units as auto; giving the results based on the geographical location
      url = "#{ weather_url }/#{ lat },#{ lng }?units=auto"

      p "IP => #{request.remote_ip}"

      response = HTTParty.get( url )

      response
    end

    # GET request for timezone
    def get_timezone
    end

    # GET request for news. Currently only supporting New York Times
    def get_news
    end


end

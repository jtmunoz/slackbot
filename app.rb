require 'sinatra'
require 'httparty'
require 'json'
require 'net/http'


# get '/' do
#   url = "http://api.giphy.com/v1/gifs/search?q=ryan+gosling&api_key=dc6zaTOxFJmzC&limit=5"
#   resp = Net::HTTP.get_response(URI.parse(url))
#   buffer = resp.body
#   result = JSON.parse(buffer) 
#   result["data"].each do |img|
#     puts img["url"]
#     puts img["images"]["fixed_height"]["width"]
#     puts img["images"]["fixed_height"]["height"]
#   end
# end

post '/gateway' do
  message = params[:text].gsub(params[:trigger_word], '').strip
  
  action, query = message.split('_').map {|c| c.strip.downcase }
  respond_message action
  respond_message query
  case action
    when 'trending'
      respond_message "INSIDE TRENDING"
      giphy_url = "http://api.giphy.com/v1/gifs/trending?api_key=dc6zaTOxFJmzC&limit=1"     
      respond_message "#{giphy_url}"
      resp = HTTParty.get(giphy_url)
      resp = JSON.parse resp.body
      resp["data"].each {|gif| respond_message gif["url"]}
  
    when 'search'
      giphy_url = "http://api.giphy.com/v1/gifs/search?q=#{query}&api_key=dc6zaTOxFJmzC&limit=1"
      resp = HTTParty.get(giphy_url)
      resp = JSON.parse resp.body
      resp["data"].each do |img|
        respond_message img["url"]
        # respond_message img["images"]["fixed_height"]["width"]
        # respond_message img["images"]["fixed_height"]["height"]
      end 
  end
end

def respond_message message
  content_type :json
  {:text => message}.to_json
end
require 'sinatra'
require 'httparty'
require 'json'
require 'net/http'

get '/' do
  redirect '/gateway' 
end

get '/gateway' do
  haml :gateway
end

post '/gateway' do
  message = params[:text].gsub(params[:trigger_word], '').strip
  message = message.split(' ').map {|c| c.strip.downcase }
  action = message[0]
  message.shift
  query = message.join('+') 
  case action
    when 'trending'
      giphy_url = "http://api.giphy.com/v1/gifs/trending?api_key=dc6zaTOxFJmzC&limit=1"
      resp = HTTParty.get(giphy_url)
      buffer = resp.body
      result = JSON.parse(buffer)        
      respond_message result["data"][0]["url"]
    when 'search'
      giphy_url = "http://api.giphy.com/v1/gifs/search?q=#{query}&api_key=dc6zaTOxFJmzC&limit=1"
      resp = HTTParty.get(giphy_url)
      buffer = resp.body
      result = JSON.parse(buffer)        
      respond_message result["data"][0]["url"]
  end
end

def respond_message message
  content_type :json
  {:text => message}.to_json
end
      
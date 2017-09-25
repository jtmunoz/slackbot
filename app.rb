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
  # puts params
  message = params[:text].gsub(params[:trigger_word], '').strip
  # puts message
  message = message.split(' ').map {|c| c.strip.downcase }
  # puts message
  action = message[0]
  message.shift
  query = message.join('+') 
  case action
    when 'trending'
      giphy_url = "http://api.giphy.com/v1/gifs/trending?api_key=dc6zaTOxFJmzC&limit=5"
      # puts giphy_url
      resp = HTTParty.get(giphy_url)
      # puts resp
      buffer = resp.body
      # puts buffer
      result = JSON.parse(buffer) 
      puts "HERE  " * 10       
      puts result
      @src =  result["data"][rand(0...5)]["url"]["text"]
      # @src = respond_message result["data"][rand(0..25)]["url"]
      puts @src
      haml :gif
    when 'search'
      giphy_url = "http://api.giphy.com/v1/gifs/search?q=#{query}&api_key=dc6zaTOxFJmzC&limit=1"
      resp = HTTParty.get(giphy_url)
      buffer = resp.body
      result = JSON.parse(buffer)        
      respond_message result["data"][0]["url"]
  end
end

# def respond_message message
#   content_type :json
#   {:text => message}.to_json
# end
      
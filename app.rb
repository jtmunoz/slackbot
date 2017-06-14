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

get '/' do
  redirect '/gateway' 
end

get '/gateway' do
  haml :gateway
end

post '/gateway' do
  message = params[:text].gsub(params[:trigger_word], '').strip
  # # query = params[:text].gsub(params[:trigger_word], '').strip

  # # action, repo = message.split('_').map {|c| c.strip.downcase }
  action, query = message.split('_').map {|c| c.strip.downcase }

  # repo_url = "https://api.github.com/repos/#{repo}"
  # giphy_url = "http://api.giphy.com/v1/gifs/search?q=#{query}&api_key=dc6zaTOxFJmzC&limit=5"
  # giphy_url = "http://api.giphy.com/v1/gifs/trending?api_key=dc6zaTOxFJmzC"

  case action
      when 'trending'
        giphy_url = "http://api.giphy.com/v1/gifs/trending?api_key=dc6zaTOxFJmzC&limit=2"
        
        resp = HTTParty.get(giphy_url)
    

        buffer = resp.body
          # puts "buffer" * 10
          

        result = JSON.parse(buffer) 
          # puts "results" * 10
          # puts result
          # puts result.class

       
        respond_message result["data"][0]["url"]
        

        # result["data"].each do |gif|
        #     puts gif["url"] 
        #     message << gif["url"]
        # end

        # puts message
        # respond_message result["data"]["url"]

        
        # puts result["data"].length
        
  end
  #   when 'search'
  #     # resp = HTTParty.get(repo_url)
  #     resp = HTTParty.get(giphy_url)

  #     resp = JSON.parse resp.body
      
  #     # respond_message "There are #{resp['open_issues_count']} open issues on #{repo}"
  #     # respond_message "#{resp['body']}"
  #      result["data"].each do |img|
  #       puts img["url"]
  #       puts img["images"]["fixed_height"]["width"]
  #       puts img["images"]["fixed_height"]["height"]
  #     end 
  # end
  # message = "#{params.inspect} #{action} #{query}"
  # respond_message "#{params.inspect}, #{action}, #{query}"
end

def respond_message message
  content_type :json
  {:text => message}.to_json
end

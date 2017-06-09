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

  action, repo = message.split('_').map {|c| c.strip.downcase }
  repo_url = "https://api.github.com/repos/#{repo}"

  case action
    when 'issues'
      resp = HTTParty.get(repo_url)
      resp = JSON.parse resp.body
      respond_message "There are #{resp['open_issues_count']} open issues on #{repo}"
  end
end

def respond_message message
  content_type :json
  {:text => message}.to_json
end
module Giphy
  
  def determine_action action
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

end
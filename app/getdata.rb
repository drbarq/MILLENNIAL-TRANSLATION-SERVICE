require "pry"
require_all "./app"

class GetData

  def self.get_word_definition(word)

    url = "https://mashape-community-urban-dictionary.p.rapidapi.com/define?term=" #basic URI for the API endpoint

    @@data = RestClient::Request.execute(method: :get, url: url+word,               #api request for the data
    headers:{
      "X-RapidAPI-Host" => "mashape-community-urban-dictionary.p.rapidapi.com",
      "X-RapidAPI-Key" => "063d2b18cfmsh050bcc9a2c51cafp115f0ajsn4ba2d5acb4ff"
    })

    @@response = JSON.parse(@@data)
  end



  def self.definition(word)
    @@response["list"][0]["definition"]
  end


  def self.word(word)
    @@response["list"][0]["word"]
  end

end

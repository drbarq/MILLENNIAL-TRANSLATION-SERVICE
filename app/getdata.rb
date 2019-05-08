require "pry"
require_all "./app"

class GetData

  # binding.pry

  def self.get_word_definition(word)

    url = "https://mashape-community-urban-dictionary.p.rapidapi.com/define?term=" #basic URI for the API endpoint

    @@data = RestClient::Request.execute(method: :get, url: url+word,               #api request for the data
    headers:{
      "X-RapidAPI-Host" => "mashape-community-urban-dictionary.p.rapidapi.com",
      "X-RapidAPI-Key" => "c78a9f92ccmshd2c7b8729d31c74p182394jsnceaa306eed5d"
    })

    @@response = JSON.parse(@@data)
  end

# binding.pry


    # definition = @@response["list"][0]["definition"]
  #return 1 or 10?
  # https://rapidapi.com/community/api/urban-dictionary


  # @@response["list"][0] == nil   no response
  # puts definition



  def self.definition(word)
    @@response["list"][0]["definition"]
  end
# GetData.get_word_definition(word)["list"].empty?
  def self.word(word)
    @@response["list"][0]["word"]
  end

end

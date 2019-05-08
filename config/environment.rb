require "sinatra/activerecord"
require "pry"
require "require_all"
require_all "./app"

ActiveRecord::Base.establish_connection({
 :adapter => "sqlite3",
 :database => "./db/millenial_translator.db"
})


binding.pry
# mta_hello
#
# User.create(user_name: "Joe")
#
# Word.create(word: "Lit", definition: "Very Good")
# Favorite.all
# Favorite.create(favorite_word: "Lit")

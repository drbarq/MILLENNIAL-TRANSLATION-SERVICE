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

# User.find_by(user_name: "Joe")
# Word.find_by(word: "Lit")
# Word.find_by(word: "Lit").id
# Word.find_by(word: "Lit").word
# Favorite.create(favorite_word: Word.find_by(word: "Lit").word, user_id: User.find_by(user_name: "Joe").id, word_id:  Word.find_by(word: "Lit").id)    

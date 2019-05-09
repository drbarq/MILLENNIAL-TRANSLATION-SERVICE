require "pry"
require "rest-client"
require "json"

#I need to pass name into all the methods or set as global variable

def mts_hello
  puts "Hello! Welcome to the Millennial Translation Service. Please enter your name."

  name = gets.chomp
  # take the name and search to see if they have an account
  if User.exists?(user_name: name) #if returning user, display options, User.find_user returns the object if found
    puts "Welcome back, #{name.capitalize}!"
    mts_step_one(name)
  else  #if the user is new, create a new user
    puts "This is the first time we have seen you, #{name.capitalize}. Let's show you around."
    User.create(user_name: name)
    new_user_orientation(name)
  end
end

def mts_step_one(name) #This is the 'main menu' the screen to return
  puts "1 - Search for a new word"
  puts "2 - Display your favorite words"
  puts "3 - Exit"

  select = gets.chomp

  case select
    when "1"    #Chomp returns a string!!!
      # new word search
      puts "Please enter a word to search."
      word = gets.chomp                                   #make everything lowercase to avoid search issues ?
      word_search(word, name)                             #hits word_search to search the words db and api

    when "2"
      # find and return favorite word list for user
      puts "Here is a list of your favorite words."

      user_id = User.find_by(user_name: name).id
      user_favorites = Favorite.where(user_id: user_id).pluck(:favorite_word)   #returns all that are for the user_id

      puts user_favorites.last(5)

      mts_step_one(name)

    when "3"
      # exit
      puts "Y'all come back now, ya hear?!"

    else
      puts "Sorry, we didn't get that. Please try again."
      mts_step_one(name)
    end
end

def mts_step_two(word, name)
  puts "1 - Search for a new word"
  puts "2 - Display your favorite words"
  puts "3 - Add '#{word}' to your favorite words"
  puts "4 - Exit"

  select = gets.chomp

  case select
    when "1" #Chomp returns a string!!!
      # new word search
      puts "Please enter a word to search."
      word = gets.chomp                                           #make everything lowercase to avoid search issues ?
      word_search(word, name)                                     #method that searches the dictionary

    when "2"
      # find and return favorite word list for user
      puts "Here is a list of your favorite words." #NO fav words? puts you have none.

      user_id = User.find_by(user_name: name).id
      user_favorites = Favorite.where(user_id: user_id).pluck(:favorite_word)   #returns all that are for the user_id

      puts user_favorites.last(5)

      mts_step_one(name)

    when "3"  #add the word to the favorites table and return the favorites
      puts "Adding '#{word}' to your favorites."
      sleep 1 #wait 1 second

      user_id = User.find_by(user_name: name).id
      word_id = Word.find_by(word: word).id
      word = Word.find_by(word: word).word

      Favorite.create(favorite_word: word, user_id: user_id, word_id: word_id)

      puts "'#{word}' was added to your favorites."

      mts_step_one(name)

    when "4"
      # exit
      puts "Y'all come back now, ya hear?!"

    else
      puts "Sorry, we didn't get that. Please try again."
      mts_step_two(word, name)
    end

end


def word_search(word, name)                        #Search the words DB for the word definition.
                                                   #IF the word isn't in the words db then call the API
                                                   #IF the API returns something, store that word in the words DB
                                                   #Return the definition to the user
                                                   #IF nothing is returned ask them to try again

  if Word.exists?(word: word)                      #check the db first
    puts "'#{word.capitalize}' means #{Word.find_by(word: word).definition}."
    mts_step_two(word, name)

  elsif GetData.get_word_definition(word)["list"]  #IF not in DB call the API,
                                                   #if it is found, add the word to the words DB and return the definition
    word = GetData.word(word)                      # - the word the API found
    definition = GetData.definition(word).delete('[]')          # - the definition the API found
                                                   # **** I think the word variable is overwritten at this point with the returned word that will be passed to mts_two
    Word.create(word: word, definition: definition)#create a new word object
    puts "#{word}: #{definition}"                  #return the word and def to the user
    mts_step_two(word, name)
  else
    puts "We dont seem to know that one. Sorry!"
    mts_step_one(word, name)
  end
end

#only used once, when a new user uses it for the fist time
def new_user_orientation(name)
  puts "This is a text dictionary with simple commands."
  puts "To execute a command, input the command number."
  puts "When searching for a word, limit your input to just the word."
  puts "Now that you're signed up, we can keep track"
  puts "of your favorite words. (limit 5 words)"

  puts "1 - Search for a new word"
  puts "2 - Exit"

  select = gets.chomp

  case select
    when "1"    #Chomp returns a string!!!
      # new word search
      puts "Please enter a word to search."
      word = gets.chomp                                               #make everything lowercase to avoid search issues ?
      word_search(word, name) #method that searches the dictionary

    when "2"
      # exit
      puts "Y'all come back now, ya hear?!"

    else
      puts "Sorry, we didn't get that. Please try again."
      new_user_orientation(name)
  end

end

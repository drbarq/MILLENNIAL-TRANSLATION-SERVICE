require "pry"
require "rest-client"
require "json"
require "colorize"

# name is passed into every method

def mts_hello
  puts "Hello! Welcome to the Millennial Translation Service. Please enter your name.".colorize(:light_green)

  name = gets.chomp.capitalize
  # take the name and search to see if they have an account
  if User.exists?(user_name: name) # if returning user, display options, User.find_user returns the object if found
    puts "Welcome back, #{name.capitalize}!".colorize(:light_green)
    mts_step_one(name)
  else  # if the user is new, create a new user
    puts "This is the first time we have seen you, #{name.capitalize.underline}. Let's show you around.".colorize(:light_green)
    User.create(user_name: name)
    new_user_orientation(name)
  end
end

def mts_step_one(name) # This is the 'main menu' the screen to return
  puts "1 - Search for a new word".colorize(:light_cyan)
  puts "2 - Display your favorite words".colorize(:light_cyan)
  puts "3 - Exit".colorize(:red)

  select = gets.chomp

  case select
    when "1"    # Chomp returns a string!!!
      # new word search
      puts "Please enter a word to search.".colorize(:light_green)
      word = gets.chomp                               #make everything lowercase to avoid search issues ?
      word_search(word, name)                             #hits word_search to search the words db and api

    when "2"
      # find and return favorite word list for user
      puts "Here is a list of your favorite words.".colorize(:light_green)

      user_id = User.find_by(user_name: name).id
      user_favorites = Favorite.where(user_id: user_id).pluck(:favorite_word)   # returns all that are for the user_id

      puts user_favorites.last(5)

      mts_step_one(name)

    when "3"
      # exit
      puts "Y'all come back now, ya hear?!".colorize(:light_green)

    else
      puts "Sorry, we didn't get that. Please try again.".colorize(:light_green)
      mts_step_one(name)
    end
end

def mts_step_two(word, name)
  puts "1 - Search for a new word".colorize(:light_cyan)
  puts "2 - Display your favorite words".colorize(:light_cyan)
  puts "3 - Add '#{word}' to your favorite words".colorize(:light_cyan)
  puts "4 - Exit".colorize(:red)

  select = gets.chomp

  case select
    when "1" # Chomp returns a string!!!
      # new word search
      puts "Please enter a word to search.".colorize(:light_green)
      word = gets.chomp
      word_search(word, name)                                     # method that searches the dictionary

    when "2"
      # find and return favorite word list for user
      puts "Here is a list of your favorite words.".colorize(:light_green)

      user_id = User.find_by(user_name: name).id
      user_favorites = Favorite.where(user_id: user_id).pluck(:favorite_word)   # returns all that are for the user_id

      puts user_favorites.last(5)

      mts_step_one(name)

    when "3"  # add the word to the favorites table and return the favorites
      puts "Adding '#{word}' to your favorites.".colorize(:light_green)
      sleep 1 # wait 1 second

      user_id = User.find_by(user_name: name).id
      word_id = Word.find_by(word: word).id
      word = Word.find_by(word: word).word

      Favorite.create(favorite_word: word, user_id: user_id, word_id: word_id)

      puts "'#{word.capitalize}' was added to your favorites.".colorize(:light_green)

      mts_step_one(name)

    when "4"
      # exit
      puts "Y'all come back now, ya hear?!".colorize(:light_green)

    else
      puts "Sorry, we didn't get that. Please try again.".colorize(:light_green)
      mts_step_two(word, name)
    end

end


def word_search(word, name)                        # Search the words DB for the word definition.
                                                   # If the word isn't in the words db then call the API
                                                   # If the API returns something, store that word in the words DB
                                                   # Return the definition to the user
                                                   # If nothing is returned ask them to try again

  if Word.exists?(word: word)                      # check the db first
    puts "'#{word.capitalize}' means #{Word.find_by(word: word).definition}."
    mts_step_two(word, name)

  elsif GetData.get_word_definition(word)["list"]  # If not in DB call the API,
                                                   # if it is found, add the word to the words DB and return the definition
    word = GetData.word(word)                      # - the word the API found
    definition = GetData.definition(word).delete('[]')          # - the definition the API found
                                                   # **** I think the word variable is overwritten at this point with the returned word that will be passed to mts_two
    Word.create(word: word, definition: definition)# create a new word object
    puts "#{word}: #{definition.delete('[]')}"                  # return the word and def to the user
    mts_step_two(word, name)
  else
    puts "We don't recognize that one. Sorry!".colorize(:light_green)
    mts_step_one(word, name)
  end
end

# only used once, when a new user uses it for the fist time
def new_user_orientation(name)
  puts "This is a text dictionary with simple commands.".colorize(:light_magenta)
  puts "To execute a command, input the command number.".colorize(:light_magenta)
  puts "When searching for a word, limit your input to just the word.".colorize(:light_magenta)
  puts "Now that you're signed up, we can keep track".colorize(:light_magenta)
  puts "of your favorite words. (limit 5 words)".colorize(:light_magenta)

  puts "1 - Search for a new word".colorize(:light_cyan)
  puts "2 - Exit".colorize(:red)

  select = gets.chomp

  case select
    when "1"    # Chomp returns a string!!!
      # new word search
      puts "Please enter a word to search.".colorize(:light_green)
      word = gets.chomp
      word_search(word, name) # method that searches the dictionary

    when "2"
      # exit
      puts "Y'all come back now, ya hear?!".colorize(:light_green)

    else
      puts "Sorry, we didn't get that. Please try again.".colorize(:light_green)
      new_user_orientation(name)
  end

end

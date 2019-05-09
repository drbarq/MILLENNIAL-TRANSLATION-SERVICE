require "sinatra/activerecord"
require "pry"
require "require_all"
require_all "./app"

ActiveRecord::Base.logger = nil

ActiveRecord::Base.establish_connection({
 :adapter => "sqlite3",
 :database => "./db/millenial_translator.db"
})


#code starts here
mts_hello

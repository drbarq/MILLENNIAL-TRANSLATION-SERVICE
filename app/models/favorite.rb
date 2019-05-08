class Favorite < ActiveRecord::Base
  belongs_to :users
  belongs_to :words
end



# ➜  Final_Project rake db:migrate:status
#
# database: ./db/millenial_translator.db
#
#  Status   Migration ID    Migration Name
# --------------------------------------------------
#    up     20190508014553  Users table
#    up     20190508014636  Words table
#    up     20190508014655  Users favorites  table

# https://github.com/rails/rails/blob/b9ca94caea2ca6a6cc09abaffaad67b447134079/activerecord/lib/active_record/errors.rb#L100
# => #<UserFavorite::ActiveRecord_Relation:0x3feaa930063c>
# [6] pry(main)> UserFavorite.create
# ActiveRecord::StatementInvalid: Could not find table 'user_favorites'
# from /Users/joetustin/.rvm/gems/ruby-2.6.1/gems/activerecord-5.2.3/lib/active_record/connection_adapters/sqlite3_adapter.rb:397:in `t
# able_structure'



# => #<UserFavorite::ActiveRecord_Relation:0x3fc8f3ca00e8>
# [9] pry(main)> UserFavorite.allWord
# NoMethodError: undefined method `allWord' for UserFavorite(Table doesn't exist):Class
# from /Users/joetustin/.rvm/gems/ruby-2.6.1/gems/activerecord-5.2.3/lib/active_record/dynamic_matchers.rb:22:in `method_missing'
# [10] pry(main)> Word
# => Word(id: integer, defined_word: string, definition: string)
# [11] pry(main)> User
# => User(id: integer, user_name: string)
# [12] pry(main)> UserFavorite
# => UserFavorite(Table doesn't exist)

# [5] pry(main)> UserFavorite.all
# D, [2019-05-08T07:01:41.291091 #713] DEBUG -- :   UserFavorite Load (0.3ms)  SELECT "user_favorites".* FROM "user_favorites"
# D, [2019-05-08T07:01:41.291799 #713] DEBUG -- :   UserFavorite Load (0.2ms)  SELECT  "user_favorites".* FROM "user_favorites" LIMIT ?
#   [["LIMIT", 11]]

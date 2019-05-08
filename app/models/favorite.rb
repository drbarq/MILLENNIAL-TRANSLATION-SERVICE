class Favorite < ActiveRecord::Base
  belongs_to :users
  belongs_to :words
end

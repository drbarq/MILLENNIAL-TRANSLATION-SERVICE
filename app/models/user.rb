class User < ActiveRecord::Base
  has_many :favorites
  has_many :words, through: :favorites
end

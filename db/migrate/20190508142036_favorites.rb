class Favorites < ActiveRecord::Migration[5.2]
  def change
    create_table :favorites do |t|
      t.string :favorite_word
      t.references :user
      t.references :word
    end
  end
end

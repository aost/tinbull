class AddPasswordHashesToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :password_hashes, :text
  end
end

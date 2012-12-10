class RemovePasswordHashesFromTopics < ActiveRecord::Migration
  def up
    remove_column :topics, :password_hashes
  end

  def down
    add_column :topics, :password_hashes, :text
  end
end

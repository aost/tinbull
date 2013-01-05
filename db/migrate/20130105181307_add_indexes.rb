class AddIndexes < ActiveRecord::Migration
  def change
    add_index :posts, :topic_id
    add_index :topics, :section
    add_index :users, :ip
  end
end

class RemoveTextFromTopics < ActiveRecord::Migration
  def up
    remove_column :topics, :text
  end

  def down
    add_column :topics, :text, :text
  end
end

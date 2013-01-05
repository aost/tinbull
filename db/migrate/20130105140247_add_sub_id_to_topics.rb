class AddSubIdToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :sub_id, :integer
  end
end

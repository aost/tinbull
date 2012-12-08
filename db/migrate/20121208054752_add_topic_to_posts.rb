class AddTopicToPosts < ActiveRecord::Migration
  def change
    change_table :posts do |t|
      t.references :topic
    end
  end
end

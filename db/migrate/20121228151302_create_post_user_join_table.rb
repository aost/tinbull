class CreatePostUserJoinTable < ActiveRecord::Migration
  def change
    create_table :posts_users, id: false do |t|
      t.integer :flagged_post_id
      t.integer :flagger_id
    end
  end
end

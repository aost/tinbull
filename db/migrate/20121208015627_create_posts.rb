class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.text :text
      t.string :password_hash

      t.timestamps
    end
  end
end

class RemoveIpFromPosts < ActiveRecord::Migration
  def up
    remove_column :posts, :ip
  end

  def down
    add_column :posts, :ip, :string
  end
end

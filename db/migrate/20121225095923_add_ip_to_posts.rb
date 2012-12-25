class AddIpToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :ip, :string
  end
end

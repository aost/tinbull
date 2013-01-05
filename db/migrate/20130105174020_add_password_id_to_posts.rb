class AddPasswordIdToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :password_id, :string
  end
end

class AddSubIdToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :sub_id, :integer
  end
end

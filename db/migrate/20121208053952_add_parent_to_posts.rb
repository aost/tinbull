class AddParentToPosts < ActiveRecord::Migration
  def change
    change_table :posts do |t|
      t.references :parent
    end
  end
end

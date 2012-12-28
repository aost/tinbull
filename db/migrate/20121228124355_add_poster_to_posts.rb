class AddPosterToPosts < ActiveRecord::Migration
  def change
    change_table :posts do |t|
      t.references :poster
    end
  end
end

class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :ip
      t.boolean :blocked, default: false

      t.timestamps
    end
  end
end

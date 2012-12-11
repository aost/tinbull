class RemoveSectionsAndAddSectionToTopics < ActiveRecord::Migration
  def up
    drop_table :sections
    remove_column :topics, :section_id
    add_column :topics, :section, :string
  end

  def down
    create_table :sections do |t|
      t.string :name
    end
    remove_column :topics, :section
    add_column :topics, :section_id, :integer
  end
end

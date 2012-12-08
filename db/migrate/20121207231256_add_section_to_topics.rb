class AddSectionToTopics < ActiveRecord::Migration
  change_table(:topics) { |t| t.belongs_to :section }
end

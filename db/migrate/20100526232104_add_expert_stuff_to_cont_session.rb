class AddExpertStuffToContSession < ActiveRecord::Migration
  def self.up
    add_column :contouring_sessions, :expert, :boolean
    add_column :contouring_sessions, :expert_note, :string
  end

  def self.down
    remove_column :contouring_sessions, :expert_note
    remove_column :contouring_sessions, :expert
  end
end

class AddStatusFlagToCountouring < ActiveRecord::Migration
  def self.up
    
    add_column :contouring_sessions, :ready, :boolean
    
  end

  def self.down
    remove_column :contouring_sessions, :ready
  end
end

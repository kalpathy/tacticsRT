class AddStructureSetIdToStructures < ActiveRecord::Migration
  def self.up
    change_table :structures do |t|
      t.references :structure_set
    end
  end

  def self.down
   remove_column :structure_set_id
  end
end

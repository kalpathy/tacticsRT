class CreateStructures < ActiveRecord::Migration
  def self.up
    create_table :structures do |t|
      t.integer  :contouring_session_id
      t.string  :structure_name
      t.string :mask_file_name
      t.string :mask_content_type
      t.integer :mask_file_size
      t.datetime :mask_updated_at

      t.timestamps
    end
  end

  def self.down
    drop_table :structures
  end
end

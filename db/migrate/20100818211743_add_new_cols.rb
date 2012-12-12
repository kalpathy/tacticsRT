class AddNewCols < ActiveRecord::Migration
  def self.up

	add_column :contouring_sessions, :name, :string
    	add_column :structures, :rt_modality, :string
    	add_column :structures, :rt_roi_num, :string
    	add_column :structures, :rt_description, :string

  end

  def self.down

	remove_column :contouring_sessions, :name
	remove_column :structures, :rt_modality, :string
    	remove_column :structures, :rt_roi_num, :string
    	remove_column :structures, :rt_description, :string 

  end
end

class CreateContours < ActiveRecord::Migration
  def self.up
    create_table :contours do |t|
	t.column :structure_id, :integer
	t.column :ref_roi_num, :string
	t.column :ref_sop_instance_uid, :string
	t.column :cont_data, :text
      t.timestamps
    end
  end

  def self.down
    drop_table :contours
  end
end

class CreateContouringSessions < ActiveRecord::Migration
  def self.up
    create_table :contouring_sessions do |t|
      t.integer  :user_id
      t.integer :template_study_id
      t.string :rtstruct_file_name
      t.string :rtstruct_content_type
      t.integer :rtstruct_file_size
      t.datetime :rtstruct_updated_at
      

      t.timestamps
    end
  end

  def self.down
    drop_table :contouring_sessions
  end
end

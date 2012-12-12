class CreateTemplateStudies < ActiveRecord::Migration
  def self.up
    create_table :template_studies do |t|
      t.string  :name
      t.string  :description
      t.text  :metadata
      t.string :nii_file_name
      t.string :nii_content_type
      t.integer :nii_file_size
      t.datetime :nii_updated_at
      
      t.timestamps
    end
  end

  def self.down
    drop_table :template_studies
  end
end

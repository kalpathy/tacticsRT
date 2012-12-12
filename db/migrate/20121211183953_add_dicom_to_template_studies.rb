class AddDicomToTemplateStudies < ActiveRecord::Migration
  def self.up
    add_column :template_studies, :ts_dicom, :string
    add_column :template_studies, :ts_json, :string
  end

  def self.down
    remove_column :template_studies, :ts_dicom
    remove_column :template_studies, :ts_json
  end
end

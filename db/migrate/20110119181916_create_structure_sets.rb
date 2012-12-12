class CreateStructureSets < ActiveRecord::Migration
  def self.up
    create_table :structure_sets do |t|
      t.references :template_study
      t.string :name
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :structure_sets
  end
end

class CreateMetrics < ActiveRecord::Migration
  def self.up
    create_table :metrics do |t|
      t.integer  :metric_type_id
      t.integer :structure_1_id
      t.integer :structure_2_id
      t.text :value
      t.timestamps
    end
  end

  def self.down
    drop_table :metrics
  end
end

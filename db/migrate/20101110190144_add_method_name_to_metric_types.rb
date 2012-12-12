class AddMethodNameToMetricTypes < ActiveRecord::Migration
  def self.up
    add_column :metric_types, :method_name, :string
  end

  def self.down
    remove_column :metric_types, :method_name
  end
end

class AddExtraUserColumns < ActiveRecord::Migration
  def self.up
    add_column :users, :organization, :string
    add_column :users, :research_area, :string
    add_column :users, :how_learned, :string
    add_column :users, :website, :string
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
  end

  def self.down
    remove_column :users, :last_name
    remove_column :users, :first_name
    remove_column :users, :website
    remove_column :users, :how_learned
    remove_column :users, :research_area
    remove_column :users, :organization
  end
end

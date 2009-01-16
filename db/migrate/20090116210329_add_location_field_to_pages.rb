class AddLocationFieldToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :location, :string
  end

  def self.down
    remove_column :pages, :location
  end
end

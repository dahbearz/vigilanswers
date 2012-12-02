class ChangeAddressTableToHaveFloatCoordsAndAddressColumn < ActiveRecord::Migration
  def self.up
    add_column :reports, :address, :string
    change_table :reports do |t|
      t.change :latitude, :float
      t.change :longitude, :float
    end
  end

  def self.down
    remove_column :reports, :address
    change_table :reports do |t|
      t.change :latitude, :integer
      t.change :longitude, :integer
    end
  end
end

class CreateLocationsTable < ActiveRecord::Migration
  def up
    create_table :locations do |t|
      t.integer :latitude, :limit => 8
      t.integer :longitude, :limit => 8
    end
  end

  def down
  end
end

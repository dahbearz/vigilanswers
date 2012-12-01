class AddLocationToReports < ActiveRecord::Migration
  def change
    add_column :reports, :longitude, :integer
    add_column :reports, :latitude, :integer
  end
end

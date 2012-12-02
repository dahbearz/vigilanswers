class AddTimestampsToReportsForRealThisTime < ActiveRecord::Migration
  def self.up
    change_table :reports do |t|
      t.timestamps
    end
  end

  def self.down
  end
end

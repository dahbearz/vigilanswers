class AddDefaultValueToScores < ActiveRecord::Migration
  def self.up
    change_column :reports, :score, :integer, :default => 0
  end

  def self.down
    change_column :reports, :score, :integer
  end
end

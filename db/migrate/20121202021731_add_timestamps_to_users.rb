class AddTimestampsToUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.timestamps
    end
  end

  def self.down
  end
end

class CreateReportsTable < ActiveRecord::Migration
  def up
    create_table :reports do |t|
      t.string :title
      t.integer :score
      t.integer :location_id
      t.text :description
      t.boolean :resolved
    end
  end

  def down
    drop_table :reports
  end
end

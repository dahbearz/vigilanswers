class CreateReportsCategoriesTable < ActiveRecord::Migration
  def up
    create_table :categories_reports, :id => false do |t|
      t.integer :report_id
      t.integer :category_id
    end
  end

  def down
    drop_table :categories_reports
  end
end

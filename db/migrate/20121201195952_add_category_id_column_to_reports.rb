class AddCategoryIdColumnToReports < ActiveRecord::Migration
  def change
    add_column :reports, :category_id, :integer
  end
end

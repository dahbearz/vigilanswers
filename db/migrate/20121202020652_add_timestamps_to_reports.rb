class AddTimestampsToReports < ActiveRecord::Migration
  def change_table
        add_column(:reports, :created_at, :datetime)
        add_column(:reports, :updated_at, :datetime)
  end
end

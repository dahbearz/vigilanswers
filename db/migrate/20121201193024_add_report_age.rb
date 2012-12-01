class AddReportAge < ActiveRecord::Migration
  def up
    add_column :reports, :report_hour_age, :integer
  end

  def down
  end
end

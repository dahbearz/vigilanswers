class AddSmsColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :sms, :string
  end
end

class DefaultUserTable < ActiveRecord::Migration
  def up
     change_column :users, :address, :string, :default => "30332"
  end

  def down
  end
end

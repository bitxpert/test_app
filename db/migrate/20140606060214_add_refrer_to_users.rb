class AddRefrerToUsers < ActiveRecord::Migration
  def change
    add_column :users, :refrer, :integer
  end
end

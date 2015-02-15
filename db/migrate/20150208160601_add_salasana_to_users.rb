class AddSalasanaToUsers < ActiveRecord::Migration
  def change
    add_column :users, :salasana, :string
  end
end

class RemoveSalasanaFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :salasana, :string
  end
end

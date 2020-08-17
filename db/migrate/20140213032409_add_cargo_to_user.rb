class AddCargoToUser < ActiveRecord::Migration
  def change
    add_column :users, :cargo_id, :integer
  end
end

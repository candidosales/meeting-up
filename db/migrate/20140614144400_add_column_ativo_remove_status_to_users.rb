class AddColumnAtivoRemoveStatusToUsers < ActiveRecord::Migration
  def change
  	remove_column :users, :status
  	add_column :users, :ativo, :boolean, :default => false
  end
end

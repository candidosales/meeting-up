class AddColumnSetorToUser < ActiveRecord::Migration
  def change
    add_reference :users, :setor, index: true
  end
end

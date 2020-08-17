class AddColumnStatusToAssunto < ActiveRecord::Migration
  def change
    add_column :assuntos, :status, :integer
  end
end

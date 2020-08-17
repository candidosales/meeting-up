class AddColumnCodigoToReuniao < ActiveRecord::Migration
  def change
    add_column :reunioes, :codigo, :string
  end
end

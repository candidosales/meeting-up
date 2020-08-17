class AddPrioridadeColumnsToAssuntos < ActiveRecord::Migration
  def change
    add_column :assuntos, :prioridade, :string, limit: 1
  end
end

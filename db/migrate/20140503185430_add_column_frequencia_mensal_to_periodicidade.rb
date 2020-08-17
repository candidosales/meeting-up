class AddColumnFrequenciaMensalToPeriodicidade < ActiveRecord::Migration
  def change
    add_column :periodicidades, :frequencia_mensal, :string
  end
end

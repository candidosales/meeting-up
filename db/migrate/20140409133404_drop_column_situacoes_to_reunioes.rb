class DropColumnSituacoesToReunioes < ActiveRecord::Migration
  def change
  	  remove_column :reunioes, :situacoes_id
  end
end

class ChangeTypePrioridadeInAssuntos < ActiveRecord::Migration
  def change
  	add_column :assuntos, :prioridade_int, :integer, limit: 1
  	Assunto.where(:prioridade => 'A').update_all(:prioridade_int => 1)
  	Assunto.where(:prioridade => 'M').update_all(:prioridade_int => 2)
  	Assunto.where(:prioridade => 'B').update_all(:prioridade_int => 3)
  	remove_column :assuntos, :prioridade
  	rename_column :assuntos, :prioridade_int, :prioridade
  end
end

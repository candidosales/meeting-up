class AddDataConclusaoReferenceSituacaoToAssuntos < ActiveRecord::Migration
  def change
  	add_reference :assuntos, :situacoes, index: true
  	add_column :assuntos, :data_conclusao, :datetime
  end
end

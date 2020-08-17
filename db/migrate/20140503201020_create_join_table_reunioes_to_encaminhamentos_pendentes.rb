class CreateJoinTableReunioesToEncaminhamentosPendentes < ActiveRecord::Migration
  def change
  	create_join_table :reunioes, :encaminhamentos, table_name: :reunioes_encaminhamentos_pendentes
  end
end

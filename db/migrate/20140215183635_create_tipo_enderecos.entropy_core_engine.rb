# This migration comes from entropy_core_engine (originally 20140201204538)
class CreateTipoEnderecos < ActiveRecord::Migration
  def change
    create_table :tipo_enderecos do |t|
      t.string 		:nome, null: false
      t.timestamps
      #Colocar coluna que indetifica qual cliente criou o novo tipo e uma que determine
      #se esse tipo pertence a todos os clientes
    end
  end
end

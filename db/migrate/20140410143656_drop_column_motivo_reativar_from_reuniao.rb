class DropColumnMotivoReativarFromReuniao < ActiveRecord::Migration
  def change
  	remove_column :reunioes, :motivo_reativar
  end
end

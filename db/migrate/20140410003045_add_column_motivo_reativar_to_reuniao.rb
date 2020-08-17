class AddColumnMotivoReativarToReuniao < ActiveRecord::Migration
  def change
    add_column :reunioes, :motivo_reativar, :text
  end
end

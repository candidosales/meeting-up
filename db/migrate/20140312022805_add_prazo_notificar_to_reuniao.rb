class AddPrazoNotificarToReuniao < ActiveRecord::Migration
  def change
    add_column :reunioes, :prazo_notificar, :date
  end
end

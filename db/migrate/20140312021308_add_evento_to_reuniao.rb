class AddEventoToReuniao < ActiveRecord::Migration
  def change
    add_reference :reunioes, :evento, index: true
  end
end

class AddInicioFimToReuniao < ActiveRecord::Migration
  def change
    add_column :reunioes, :inicio, :datetime
    add_column :reunioes, :fim, :datetime
  end
end

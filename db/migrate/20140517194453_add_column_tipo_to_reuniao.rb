class AddColumnTipoToReuniao < ActiveRecord::Migration
  def change
    add_column :reunioes, :tipo, :string
  end
end

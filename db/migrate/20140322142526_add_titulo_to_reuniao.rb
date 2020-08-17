class AddTituloToReuniao < ActiveRecord::Migration
  def change
    add_column :reunioes, :titulo, :string
  end
end

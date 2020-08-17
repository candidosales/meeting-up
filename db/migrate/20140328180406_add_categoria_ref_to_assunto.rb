class AddCategoriaRefToAssunto < ActiveRecord::Migration
  def change
    add_reference :assuntos, :categoria, index: true
  end
end

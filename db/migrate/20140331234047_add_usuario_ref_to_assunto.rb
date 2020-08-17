class AddUsuarioRefToAssunto < ActiveRecord::Migration
  def change
    add_reference :assuntos, :usuario, index: true
  end
end

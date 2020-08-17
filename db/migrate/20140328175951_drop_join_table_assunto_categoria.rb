class DropJoinTableAssuntoCategoria < ActiveRecord::Migration
  def change
  	drop_join_table :assuntos, :categorias
  end
end

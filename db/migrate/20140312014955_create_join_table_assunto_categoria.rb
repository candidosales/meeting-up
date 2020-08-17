class CreateJoinTableAssuntoCategoria < ActiveRecord::Migration
  def change
    create_join_table :assuntos, :categorias do |t|
      # t.index [:assunto_id, :categoria_id]
      # t.index [:categoria_id, :assunto_id]
    end
  end
end

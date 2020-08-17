class CreateJoinTableEventoToAssunto < ActiveRecord::Migration
  def change
    create_join_table :assuntos, :eventos do |t|
      # t.index [:assunto_id, :evento_id]
      # t.index [:evento_id, :assunto_id]
    end
  end
end

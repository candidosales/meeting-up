class CreateJoinTableReuniaoToAssunto < ActiveRecord::Migration
  def change
    create_join_table :assuntos, :reunioes do |t|
      # t.index [:assunto_id, :reuniao_id]
      # t.index [:reuniao_id, :assunto_id]
    end
  end
end

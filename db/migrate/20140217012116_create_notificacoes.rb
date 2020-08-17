class CreateNotificacoes < ActiveRecord::Migration
  def change
    create_table :notificacoes do |t|
      t.string :descricao
      t.boolean :status
      t.string :tipo
      t.integer :sender_id
      
      t.timestamps
    end
  end
end

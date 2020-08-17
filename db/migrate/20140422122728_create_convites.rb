class CreateConvites < ActiveRecord::Migration
  def change
    create_table :convites do |t|
      t.datetime :data_confirmacao
      t.datetime :data_recusa
      t.text :mensagem
      t.references :reuniao, index: true
      t.references :user, index: true
      t.string :status

      t.timestamps
    end
  end
end

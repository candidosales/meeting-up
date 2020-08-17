class CreateSituacoes < ActiveRecord::Migration
  def change
    create_table :situacoes do |t|
      t.string :descricao
      t.text :motivo
      t.references :user, index: true
      t.datetime :data

      t.timestamps
    end
  end
end

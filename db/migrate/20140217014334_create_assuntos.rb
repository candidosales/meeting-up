class CreateAssuntos < ActiveRecord::Migration
  def change
    create_table :assuntos do |t|
      t.string :descricao
      t.text :detalhamento
      t.text :resumo
      t.text :decisao
      t.boolean :discutido
      t.references :reuniao, index: true

      t.timestamps
    end
  end
end

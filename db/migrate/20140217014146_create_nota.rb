class CreateNota < ActiveRecord::Migration
  def change
    create_table :nota do |t|
      t.string :descricao
      t.references :usuario, index: true
      t.belongs_to :encaminhamento
      t.timestamps
    end
  end
end

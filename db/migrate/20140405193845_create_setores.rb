class CreateSetores < ActiveRecord::Migration
  def change
    create_table :setores do |t|
      t.string :descricao

      t.timestamps
    end
  end
end

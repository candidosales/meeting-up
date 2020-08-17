class CreatePeriodicidades < ActiveRecord::Migration
  def change
    create_table :periodicidades do |t|
      t.string :repeticao
      t.integer :repete_cada
      t.text :frequencia
      t.date :inicio
      t.references :evento, index: true

      t.timestamps
    end
  end
end

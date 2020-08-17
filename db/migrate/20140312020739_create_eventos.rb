class CreateEventos < ActiveRecord::Migration
  def change
    create_table :eventos do |t|
      t.string :titulo
      t.timestamp :dataInicial
      t.timestamp :dataFinal
      t.references :forum, index: true
      t.references :coordenador, index: true
      t.references :redator, index: true
      t.references :controlador, index: true

      t.timestamps
    end
  end
end

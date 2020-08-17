class CreateReunioes < ActiveRecord::Migration
  def change
    create_table :reunioes do |t|
      t.datetime :data
      t.references :coordenador, index: true
      t.references :redator, index: true
      t.references :controlador, index: true
      t.string :status
      t.datetime :datacancelamento

      t.timestamps
    end
  end
end

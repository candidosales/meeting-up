class CreateLembretes < ActiveRecord::Migration
  def change
    create_table :lembretes do |t|
      t.string :tipo
      t.integer :intervalo
      t.string :periodo

      t.timestamps
    end
  end
end

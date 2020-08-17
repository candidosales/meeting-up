class CreateCompartilhamentos < ActiveRecord::Migration
  def change
    create_table :compartilhamentos do |t|
      t.references :reuniao, index: true
      t.string :email

      t.timestamps
    end
  end
end

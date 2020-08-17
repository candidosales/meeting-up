class CreateForuns < ActiveRecord::Migration
  def change
    create_table :foruns do |t|
      t.string :nome
      t.references :coordenador, index: true
      t.belongs_to :forum_pai
      t.timestamps
    end
  end
end

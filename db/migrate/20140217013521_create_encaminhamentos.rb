class CreateEncaminhamentos < ActiveRecord::Migration
  def change
    create_table :encaminhamentos do |t|
      t.string :status
      t.string :descricao
      t.belongs_to :assunto
      t.timestamps
    end
  end
end

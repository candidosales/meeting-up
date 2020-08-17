class ChangeTypeDescricaoNota < ActiveRecord::Migration
  def change
  	change_column :nota, :descricao, :text
  end
end

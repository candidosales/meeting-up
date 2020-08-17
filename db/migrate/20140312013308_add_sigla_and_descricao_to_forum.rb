class AddSiglaAndDescricaoToForum < ActiveRecord::Migration
  def change
    add_column :foruns, :sigla, :string
    add_column :foruns, :descricao, :text
  end
end

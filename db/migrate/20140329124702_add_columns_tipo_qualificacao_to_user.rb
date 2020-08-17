class AddColumnsTipoQualificacaoToUser < ActiveRecord::Migration
  def change
    add_column :users, :tipo, :string
    add_column :users, :qualificacao, :text
  end
end

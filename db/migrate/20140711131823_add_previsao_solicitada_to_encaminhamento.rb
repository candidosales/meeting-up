class AddPrevisaoSolicitadaToEncaminhamento < ActiveRecord::Migration
  def change
    add_column :encaminhamentos, :previsao_solicitada, :date
  end
end

class AddColumnPrevisaoAntigaToEncaminhamento < ActiveRecord::Migration
  def change
    add_column :encaminhamentos, :previsao_antiga, :datetime
  end
end

class ChangeTypePrevisaoToEncaminhamento < ActiveRecord::Migration
  def change
  	change_column :encaminhamentos, :previsao, :date
  	change_column :encaminhamentos, :previsao_antiga, :date
  end
end

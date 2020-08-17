class ChangeColumnNameDataEncaminhamento < ActiveRecord::Migration
  def change
  	rename_column :encaminhamentos, :data, :previsao
  end
end

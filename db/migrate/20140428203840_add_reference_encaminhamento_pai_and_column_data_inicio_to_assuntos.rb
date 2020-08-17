class AddReferenceEncaminhamentoPaiAndColumnDataInicioToAssuntos < ActiveRecord::Migration
  def change
  	add_reference :encaminhamentos, :pai, index: true
  	add_column :encaminhamentos, :data_inicio, :datetime
  end
end

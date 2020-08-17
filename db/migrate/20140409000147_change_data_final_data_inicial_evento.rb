class ChangeDataFinalDataInicialEvento < ActiveRecord::Migration
  def change
  	rename_column :eventos, :dataFinal, :data_final
  	rename_column :eventos, :dataInicial, :data_inicial
  end
end


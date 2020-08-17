class AddArquivoColumnsToAssuntos < ActiveRecord::Migration
  def change
    add_column :assuntos, :arquivo, :binary
  end
end

class AddColumnArquivoToDocumento < ActiveRecord::Migration
  def change
    add_column :documentos, :arquivo, :binary
  end
end

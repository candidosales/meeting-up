class DropArquivoToAssunto < ActiveRecord::Migration
  def change
  	remove_column :assuntos, :arquivo
  end
end

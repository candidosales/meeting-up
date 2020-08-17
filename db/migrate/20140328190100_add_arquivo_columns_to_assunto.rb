class AddArquivoColumnsToAssunto < ActiveRecord::Migration
  def change
  	add_attachment :assuntos, :arquivo
  end
end

class AddFileToDocumento < ActiveRecord::Migration
  def change
    add_column :documentos, :file, :string
  end
end

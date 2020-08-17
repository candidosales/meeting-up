class AddColumsDocumentableToDocumento < ActiveRecord::Migration
  def change
  	 add_column :documentos, :documentable_id, :integer
     add_column :documentos, :documentable_type, :string
  end
end

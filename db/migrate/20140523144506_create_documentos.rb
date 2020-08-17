class CreateDocumentos < ActiveRecord::Migration
  def change
    create_table :documentos do |t|

      t.timestamps
    end
  end
end

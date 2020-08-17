class RenameNotaToNotas < ActiveRecord::Migration
  def change
  	rename_table :nota, :notas
  end
end

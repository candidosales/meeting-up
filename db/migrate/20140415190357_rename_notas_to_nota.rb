class RenameNotasToNota < ActiveRecord::Migration
  def change
  	rename_table :notas, :nota
  end
end

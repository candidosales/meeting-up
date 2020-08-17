class AddColumnsSituableToSituacao < ActiveRecord::Migration
  def change
    add_column :situacoes, :situable_id, :integer
    add_column :situacoes, :situable_type, :string
  end
end

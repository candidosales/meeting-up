class AddColumnFuncaoToConvites < ActiveRecord::Migration
  def change
    add_column :convites, :funcao, :string
  end
end

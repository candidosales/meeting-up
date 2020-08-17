class AddColumnCodigoToEncaminhamento < ActiveRecord::Migration
  def change
    add_column :encaminhamentos, :codigo, :string
  end
end

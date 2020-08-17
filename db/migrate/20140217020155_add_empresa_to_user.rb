class AddEmpresaToUser < ActiveRecord::Migration
  def change
    add_reference :users, :empresa, index: true
  end
end

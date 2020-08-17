class AddCategoriaPaiRefToCategoria < ActiveRecord::Migration
  def change
    add_reference :categoria, :categoria_pai, index: true
  end
end

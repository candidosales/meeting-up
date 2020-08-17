class AddLogoColumnsToEmpresa < ActiveRecord::Migration
  def change
    add_attachment :empresas, :logo
  end
end

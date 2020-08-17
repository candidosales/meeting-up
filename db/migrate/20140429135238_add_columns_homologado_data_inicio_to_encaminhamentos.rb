class AddColumnsHomologadoDataInicioToEncaminhamentos < ActiveRecord::Migration
  def change
  	add_column :encaminhamentos, :homologado, :boolean, default: false
  end
end

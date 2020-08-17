class AddColumnDataHomologacaoToEncaminhamentos < ActiveRecord::Migration
  def change
  	add_column :encaminhamentos, :data_homologacao, :datetime
  end
end

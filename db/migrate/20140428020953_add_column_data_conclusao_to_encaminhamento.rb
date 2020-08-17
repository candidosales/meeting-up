class AddColumnDataConclusaoToEncaminhamento < ActiveRecord::Migration
  def change
    add_column :encaminhamentos, :data_conclusao, :datetime
  end
end

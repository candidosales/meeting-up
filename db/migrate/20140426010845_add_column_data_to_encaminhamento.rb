class AddColumnDataToEncaminhamento < ActiveRecord::Migration
  def change
    add_column :encaminhamentos, :data, :datetime
  end
end

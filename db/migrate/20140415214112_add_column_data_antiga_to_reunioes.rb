class AddColumnDataAntigaToReunioes < ActiveRecord::Migration
  def change
    add_column :reunioes, :data_antiga, :datetime
  end
end

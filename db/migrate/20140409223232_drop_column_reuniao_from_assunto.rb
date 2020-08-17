class DropColumnReuniaoFromAssunto < ActiveRecord::Migration
  def change
  	remove_column :assuntos, :reuniao_id
  end
end

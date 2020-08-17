class AddColumnEmailedToEncaminhamentos < ActiveRecord::Migration
  def change
    add_column :encaminhamentos, :emailed, :bool, :default => false
  end
end

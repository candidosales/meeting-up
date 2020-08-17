class AddStatusToEvento < ActiveRecord::Migration
  def change
    add_column :eventos, :status, :string
  end
end

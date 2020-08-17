class AddColumnUserToEvento < ActiveRecord::Migration
  def change
    add_reference :eventos, :user, index: true
  end
end

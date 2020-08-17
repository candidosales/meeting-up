class CreateJoinTableUserToEvento < ActiveRecord::Migration
  def change
    create_join_table :users, :eventos do |t|
      # t.index [:user_id, :evento_id]
      # t.index [:evento_id, :user_id]
    end
  end
end

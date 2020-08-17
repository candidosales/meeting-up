class CreateJoinTableUserReuniao < ActiveRecord::Migration
  def change
    create_join_table :users, :reunioes do |t|
      # t.index [:user_id, :reuniao_id]
      # t.index [:reuniao_id, :user_id]
    end
  end
end

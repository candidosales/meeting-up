class CreateJoinTableUserEncaminhamento < ActiveRecord::Migration
  def change
    create_join_table :users, :encaminhamentos do |t|
      # t.index [:user_id, :encaminhamento_id]
      # t.index [:encaminhamento_id, :user_id]
    end
  end
end

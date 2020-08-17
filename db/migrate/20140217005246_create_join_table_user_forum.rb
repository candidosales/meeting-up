class CreateJoinTableUserForum < ActiveRecord::Migration
  def change
    create_join_table :users, :foruns do |t|
      # t.index [:user_id, :forum_id]
      # t.index [:forum_id, :user_id]
    end
  end
end

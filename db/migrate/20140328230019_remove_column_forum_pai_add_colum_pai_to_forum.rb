class RemoveColumnForumPaiAddColumPaiToForum < ActiveRecord::Migration
  def change
  	remove_reference :foruns, :forum_pai
  	add_reference :foruns, :pai, index: true
  end
end

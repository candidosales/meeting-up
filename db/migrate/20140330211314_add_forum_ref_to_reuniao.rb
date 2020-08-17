class AddForumRefToReuniao < ActiveRecord::Migration
  def change
    add_reference :reunioes, :forum, index: true
  end
end

class AddForumRefToAssunto < ActiveRecord::Migration
  def change
    add_reference :assuntos, :forum, index: true
  end
end

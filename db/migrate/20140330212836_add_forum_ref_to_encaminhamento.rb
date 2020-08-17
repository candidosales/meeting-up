class AddForumRefToEncaminhamento < ActiveRecord::Migration
  def change
    add_reference :encaminhamentos, :forum, index: true
  end
end

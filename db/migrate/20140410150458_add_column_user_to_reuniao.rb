class AddColumnUserToReuniao < ActiveRecord::Migration
  def change
    add_reference :reunioes, :user, index: true
  end
end

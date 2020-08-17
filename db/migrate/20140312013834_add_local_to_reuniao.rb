class AddLocalToReuniao < ActiveRecord::Migration
  def change
    add_reference :reunioes, :local, index: true
  end
end

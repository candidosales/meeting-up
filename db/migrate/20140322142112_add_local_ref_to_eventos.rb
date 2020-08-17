class AddLocalRefToEventos < ActiveRecord::Migration
  def change
    add_reference :eventos, :local, index: true
  end
end

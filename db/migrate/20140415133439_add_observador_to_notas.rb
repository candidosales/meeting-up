class AddObservadorToNotas < ActiveRecord::Migration
  def change
    add_reference :notas, :notable, polymorphic: true, index: true
  end
end

class AddColumnDestinatarioToConvites < ActiveRecord::Migration
  def change
    add_reference :convites, :destinatario, index: true
  end
end

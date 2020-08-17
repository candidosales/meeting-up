class AddColumnForumDestinoToAssunto < ActiveRecord::Migration
  def change
    add_reference :assuntos, :forum_destino, index: true
  end
end

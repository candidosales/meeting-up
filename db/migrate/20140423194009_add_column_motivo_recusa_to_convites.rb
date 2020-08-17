class AddColumnMotivoRecusaToConvites < ActiveRecord::Migration
  def change
    add_column :convites, :motivo_recusa, :text
  end
end

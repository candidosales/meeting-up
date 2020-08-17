class AddColumnEnviadoToLembretes < ActiveRecord::Migration
  def change
    add_column :lembretes, :enviado, :boolean
  end
end

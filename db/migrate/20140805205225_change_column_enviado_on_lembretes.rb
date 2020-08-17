class ChangeColumnEnviadoOnLembretes < ActiveRecord::Migration
  def change
  	change_column :lembretes, :enviado, :boolean, :default => false
  end
end

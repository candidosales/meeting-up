class ChangeColumnIntervaloToLembrete < ActiveRecord::Migration
  def change
  	change_column :lembretes, :intervalo, :integer, :default => 1
  end
end

class SetarTrueLembretesAntigos < ActiveRecord::Migration
  def change
  	Lembrete.update_all(:enviado => true)
  end
end

class RemoveEncaminhamentoRefToNotas < ActiveRecord::Migration
  def change
  	remove_reference :nota, :encaminhamento
  end
end

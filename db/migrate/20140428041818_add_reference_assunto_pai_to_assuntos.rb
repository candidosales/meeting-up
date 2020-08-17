class AddReferenceAssuntoPaiToAssuntos < ActiveRecord::Migration
  def change
  	add_reference :assuntos, :pai, index: true
  end
end

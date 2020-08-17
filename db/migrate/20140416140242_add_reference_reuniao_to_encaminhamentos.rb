class AddReferenceReuniaoToEncaminhamentos < ActiveRecord::Migration
  def change
  	add_reference :encaminhamentos, :reuniao
  end
end

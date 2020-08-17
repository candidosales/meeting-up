class DropReferenceParticipantesToReuniao < ActiveRecord::Migration
  def change
  	remove_reference :reunioes, :coordenador
  	remove_reference :reunioes, :controlador
  	remove_reference :reunioes, :redator
  	drop_join_table :users, :reunioes 
  end
end

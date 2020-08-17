class AddSituacoesToReuniao < ActiveRecord::Migration
  def change
    add_reference :reunioes, :situacoes, index: true
  end
end

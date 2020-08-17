# This migration comes from entropy_core_engine (originally 20140201204249)
class CreateEnderecos < ActiveRecord::Migration
  def change
    create_table :enderecos do |t|
	    t.belongs_to :tipo
      t.string		:logradouro
      t.integer		:numero
      t.string		:cep
      t.string		:ponto_referencia
      t.string		:complemento
      t.string    :latitude
      t.string    :longitude
      t.belongs_to :cidade
      t.belongs_to :bairro
      t.timestamps
    end
  end
end

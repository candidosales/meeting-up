# This migration comes from entropy_core_engine (originally 20140201200551)
class CreateCidades < ActiveRecord::Migration
  def change
    create_table :cidades do |t|
	  t.string	:nome
	  t.belongs_to :estado    	
      t.timestamps
    end
  end
end

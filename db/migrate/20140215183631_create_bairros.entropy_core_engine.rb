# This migration comes from entropy_core_engine (originally 20140201200544)
class CreateBairros < ActiveRecord::Migration
  def change
    create_table :bairros do |t|
	  t.string	:nome
	  t.belongs_to :cidade    	
      t.timestamps
    end
  end
end

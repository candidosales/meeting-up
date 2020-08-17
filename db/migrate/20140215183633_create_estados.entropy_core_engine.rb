# This migration comes from entropy_core_engine (originally 20140201200558)
class CreateEstados < ActiveRecord::Migration
  def change
    create_table :estados do |t|
      t.string		:nome
      t.string		:uf, limit: 2
      t.timestamps
    end
  end
end

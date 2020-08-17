class AddPeriodicidadeRefToEvento < ActiveRecord::Migration
  def change
    add_reference :eventos, :periodicidade, index: true
  end
end

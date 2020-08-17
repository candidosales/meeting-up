class AddColumnsLembretableToLembrete < ActiveRecord::Migration
  def change
  	add_column :lembretes, :lembrable_id, :integer
    add_column :lembretes, :lembrable_type, :string
  end
end

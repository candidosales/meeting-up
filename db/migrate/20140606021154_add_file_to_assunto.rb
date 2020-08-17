class AddFileToAssunto < ActiveRecord::Migration
  def change
    add_column :assuntos, :file, :string
  end
end

class AddOutrosCamposToUser < ActiveRecord::Migration
  def change
    add_column :users, :nome, :string
    add_column :users, :matricula, :string
    add_column :users, :cpf, :string
    add_column :users, :status, :boolean
  end
end

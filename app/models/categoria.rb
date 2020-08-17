# == Schema Information
#
# Table name: categorias
#
#  id               :integer          not null, primary key
#  descricao        :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#  categoria_pai_id :integer
#


class Categoria < ActiveRecord::Base

	has_and_belongs_to_many :assuntos
	belongs_to :categoria_pai,  class_name: "Categoria", :foreign_key => "categoria_pai_id"

	validates_presence_of :descricao
	validates_length_of :descricao, :minimum => 2

  scope :por_descricao, -> (desc) { where("descricao ilike ?", "%#{desc}%") }

  scope :por_categoria_pai, -> (id_cat) { where("categoria_pai_id = ?", id_cat) }

end

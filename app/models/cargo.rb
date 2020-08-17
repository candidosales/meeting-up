# == Schema Information
#
# Table name: cargos
#
#  id         :integer          not null, primary key
#  descricao  :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Cargo < ActiveRecord::Base

	validates_presence_of :descricao
	validates_uniqueness_of :descricao
	has_many :users

	scope :por_descricao, -> (desc) { where("descricao ilike ?", "%#{desc}%") }
	
end

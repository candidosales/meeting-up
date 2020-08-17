# == Schema Information
#
# Table name: setores
#
#  id         :integer          not null, primary key
#  descricao  :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Setor < ActiveRecord::Base
	scope :por_descricao, -> (desc) { where("descricao ilike ?", "%#{desc}%") }
end

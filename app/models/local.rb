# == Schema Information
#
# Table name: locais
#
#  id         :integer          not null, primary key
#  descricao  :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Local < ActiveRecord::Base

  scope :por_descricao, -> (desc) { where("descricao ilike ?", "%#{desc}%") }	
  
  def to_s
    descricao
  end
end

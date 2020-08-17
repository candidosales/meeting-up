# == Schema Information
#
# Table name: nota
#
#  id           :integer          not null, primary key
#  descricao    :text
#  usuario_id   :integer
#  created_at   :datetime
#  updated_at   :datetime
#  notable_id   :integer
#  notable_type :string(255)
#

class Nota < ActiveRecord::Base
  belongs_to :usuario, class_name: "User"
  belongs_to :notable, polymorphic: true

  validates_presence_of :descricao

  def notable_param
    "#{notable_type}_#{notable_id}"
  end

  def to_s
    descricao
  end

  def pode_excluir
  	if Time.now.hour - created_at.hour > 24
  		return false
  	end
  	return true
  end
end

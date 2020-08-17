# == Schema Information
#
# Table name: notificacoes
#
#  id         :integer          not null, primary key
#  descricao  :string(255)
#  status     :boolean
#  tipo       :string(255)
#  sender_id  :integer
#  created_at :datetime
#  updated_at :datetime
#

class Notificacao < ActiveRecord::Base

	belongs_to :reuniao
	belongs_to :encaminhamento

end

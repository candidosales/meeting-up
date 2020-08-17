# == Schema Information
#
# Table name: convites
#
#  id               :integer          not null, primary key
#  data_confirmacao :datetime
#  data_recusa      :datetime
#  mensagem         :text
#  reuniao_id       :integer
#  user_id          :integer
#  status           :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#  funcao           :string(255)
#  destinatario_id  :integer
#  motivo_recusa    :text
#

class Convite < ActiveRecord::Base
  extend Enumerize

  belongs_to :reuniao
  belongs_to :user
  belongs_to :destinatario, class_name: "User"

  enumerize :status, in: {:pendente => 'Pendente', :confirmado => 'Confirmado',
   :recusado => 'Recusado', :vencido => 'Vencido', :cancelado => 'Cancelado'}, 
    default: :pendente, predicates: true, scope: true

  enumerize :funcao, in: {:coordenador => 'COO', :redator => 'R', :controlador => 'CON',
   :participante => 'P', :convidado => 'CVD'}, predicates: true, scope: true

  scope :permitido, -> (user) {where(:destinatario => user)}

  def confirmar
  	self.status = :confirmado
  	self.data_confirmacao = Time.now
    NotificacaoMailer.delay.send(:confirmar_convite, self)
  end

  def recusar(motivo)
    self.status = :recusado
    self.data_recusa = Time.now
    self.motivo_recusa = motivo
    NotificacaoMailer.delay.send(:recusar_convite, self)
  end

  def cancelar(motivo)
    self.status = :cancelado
    mensagem = motivo
  end  

end

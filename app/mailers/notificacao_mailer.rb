class NotificacaoMailer < ActionMailer::Base
  default from: "no-reply@vikstar.com.br"

  def novo_forum(forum, participante)
  	@forum = forum
  	@participante = participante
  	mail(to: @participante.email, subject: 'Notificação de participação de novo fórum')
  end

  def remover_participante_forum(forum, participante)
    @forum = forum
    @participante = participante
    mail(to: @participante.email, subject: 'Notificação de saída de fórum')
  end

  def nova_reuniao(reuniao, convite)
  	@reuniao = reuniao
  	@convite = convite
  	mail(to: @convite.destinatario.email, subject: 'Notificação de agendamento de nova reunião')
  end

  def adiar_reuniao(reuniao, convite)
  	@reuniao = reuniao
  	@convite = convite
  	mail(to: @convite.destinatario.email, subject: 'Notificação de adiamento de reunião')
  end

  def confirmar_reuniao(reuniao, convite)
  	@reuniao = reuniao
  	@convite = convite
  	mail(to: @convite.destinatario.email, subject: 'Notificação de confirmação de reunião')
  end

  def cancelar_reuniao(reuniao, convite)
  	@reuniao = reuniao
  	@convite = convite
  	mail(to: @convite.destinatario.email, subject: 'Notificação de cancelamento de reunião')
  end

  def reativar_reuniao(reuniao, convite)
  	@reuniao = reuniao
  	@convite = convite
  	mail(to: @convite.destinatario.email, subject: 'Notificação de reativação de reunião')
  end

  def solicitar_adiar_encaminhamento(encaminhamento, participante)
    @encaminhamento = encaminhamento
    @participante = participante
    mail(to: @participante.email, subject: 'Notificação de solicitação de adiamento de encaminhamento')
  end

  def novo_encaminhamento(encaminhamento, destinatario)
    @encaminhamento = encaminhamento
    @destinatario = destinatario
    mail(to: @destinatario.email, subject: 'Notificação de novo encaminhamento')
  end  

  def adiar_encaminhamento(encaminhamento, participante)
    @encaminhamento = encaminhamento
    @participante = participante
    mail(to: @participante.email, subject: 'Notificação de adiamento de encaminhamento')
  end

  def confirmar_convite(convite)
    @convite = convite
    @coordenador = convite.reuniao.convite_coordenador.destinatario
    mail(to: @coordenador.email, subject: 'Notificação de confirmação de convite')
  end

  def recusar_convite(convite)
    @convite = convite
    @coordenador = convite.reuniao.convite_coordenador.destinatario
    mail(to: @coordenador.email, subject: 'Notificação de recusa de convite')
  end

  def compartilhar_ata(reuniao, email)
    @reuniao = reuniao
    mail(to: email, subject: "Ata da reunião '#{@reuniao.titulo}'")
  end

  def compartilhar_ata_nao_usuario(reuniao, email, usuario)
    @reuniao = reuniao
    @forum = @reuniao.forum
    @usuario = usuario
    @email = email
    string = render_to_string(:partial => 'reunioes/ata_usuario_externo.html.erb')
    attachments['ata.pdf'] = WickedPdf.new.pdf_from_string(string)
    mail(to: email, subject: "Ata da reunião '#{@reuniao.titulo}'")
  end

  def lembrete_reuniao(reuniao, convite)
    @reuniao = reuniao
    @convite = convite
    mail(to: @convite.destinatario.email, subject: 'Notificação automática de reunião')
  end

end

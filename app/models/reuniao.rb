# == Schema Information
#
# Table name: reunioes
#
#  id               :integer          not null, primary key
#  data             :datetime
#  status           :string(255)
#  datacancelamento :datetime
#  created_at       :datetime
#  updated_at       :datetime
#  local_id         :integer
#  evento_id        :integer
#  prazo_notificar  :date
#  titulo           :string(255)
#  forum_id         :integer
#  inicio           :datetime
#  fim              :datetime
#  user_id          :integer
#  data_antiga      :datetime
#  codigo           :string(255)
#  tipo             :string(255)
#

class Reuniao < ActiveRecord::Base
	extend Enumerize
  include Situable

  # :participantes, :assuntos,
  validates_presence_of :data, :data_hora, :coordenador, :redator, :titulo,
    :if => lambda { |r| r.confirmada?}
  validates_presence_of :forum

  belongs_to :evento
  belongs_to :local
  belongs_to :forum
  # usuario q criou a reunião
  belongs_to :user

  has_many :compartilhamentos
  before_validation :gerar_codigo, on: :create

  has_many :notificacoes

  has_and_belongs_to_many  :assuntos, ->{ order 'prioridade asc, descricao asc' }

  has_many :situacoes, -> { order 'data DESC' }, as: :situable

  enumerize :status, in: {:agendada => 'A', :cancelada => 'C', :realizada => 'R', :confirmada => 'CO'},
    default: :agendada, predicates: true, scope: true

  enumerize :tipo, in: {:ordinaria => 1, :extraordinaria => 2}, default: :ordinaria, predicates: true, scope: true
  
  has_many :notas, as: :notable
  has_many :encaminhamentos
  has_many :convites

  has_and_belongs_to_many :encaminhamentos_pendentes, -> { order 'previsao asc' },
      class_name: "Encaminhamento", join_table: "reunioes_encaminhamentos_pendentes"

  scope :data_inicio, -> (data) { where("data >= ? ", data.to_datetime)}
  scope :data_fim, -> (data) { where("data <= ? ", data.to_datetime)}

  scope :no_periodo, -> (data, forum) {where(:created_at => data.beginning_of_year.. data.end_of_year,
      :forum => forum)}

  attr_accessor :data_hora, :coordenador, :redator, :controlador, :participantes, :convidados

  after_initialize :relacionar_participantes
  before_validation :set_data

  def set_data
    if !self.data.nil?
      self.data = "#{I18n.l self.data.to_date} #{self.data_hora}:00" # converte os dois campos pro formato datetime
    end
  end 

  def pode_iniciar?
    #verificar se determina um período minimo pra permitir o inicio da reuniao.
    #Tipo, faltando um dia, algumas horas ou alguns minutos pra reunião
    self.status.confirmada? && self.inicio.nil? && self.fim.nil?
  end

  def iniciada?
    self.status.confirmada? && !self.inicio.nil? && self.fim.nil?
  end

  def iniciar
    self.inicio = DateTime.now
  end

  def encerrar(user)
    self.fim = DateTime.now
    self.status = :realizada
    criar_situacao(self, self.status_text, "Encerramento da reunião", user)

    assuntos = []
    self.assuntos.each do |assunto|
      assuntos << assunto
    end

    self.encaminhamentos_pendentes.each do |enc|
      assuntos << enc.assunto
      enc.homologar_pai
    end

    assuntos.each do |assunto|
      assunto.discutido = assunto.notas.any? ? true : false
      assunto.definir_situacao_encerrar_reuniao(user)
      assunto.save
    end

    if self.ordinaria?
      self.evento.criar_reuniao(user)
    end
  end

  def reativar (motivo, user)
    self.status = :agendada
    criar_situacao(self, self.status_text, motivo, user)
  end

  def cancelar(motivo, user)
    transaction do
      self.status = :cancelada
      criar_situacao(self, self.status_text, motivo, user)
      self.convites.each do |convite|
        convite.cancelar(motivo)
        convite.save
      end 
      self.save!(validate: false)
    end
  end

  def validar_adiamento (data)
    begin
      if (Time.parse(data) <= Time.now)
        raise "A data informada deve ser maior que a atual."
      end
    rescue => e
      raise "A data informada é inválida"
    end

  end

  def criar_situacao_agendada (user)
    criar_situacao(self, self.status_text, "Agendamento da reunião", user)
  end

  def situacao_atual
    return self.situacoes.last
  end

  def enviar_notificacao(tipo)
    self.convites.each do |convite|
      if(!convite.status.recusado?)
        NotificacaoMailer.delay.send(tipo, self, convite)
      end  
    end
  end

  def criar_convites (mensagem, user)
    convite_coordenador = self.convite_coordenador
    if !self.coordenador.nil? && (convite_coordenador.nil? || convite_coordenador.destinatario != self.coordenador)
      convites << Convite.create(mensagem: mensagem, user: user, funcao: :coordenador,
        reuniao: self, destinatario: self.coordenador)
      if !convite_coordenador.nil?
        convite_coordenador.cancelar("Troca de coordenador")
        convite_coordenador.save
      end
    end

    convite_redator = self.convite_redator
    if !self.redator.nil? && (convite_redator.nil? || convite_redator.destinatario != self.redator)
      convites << Convite.create(mensagem: mensagem, user: user, funcao: :redator,
       reuniao: self, destinatario: self.redator)
      if !convite_redator.nil?
        convite_redator.cancelar("Troca de redator")
        convite_redator.save
      end
    end
    
    convite_controlador = self.convite_controlador
    
    if (!self.controlador.nil? && self.controlador.is_a?(User)) && (convite_controlador.nil? || convite_controlador.destinatario != self.controlador)
      convites << Convite.create(mensagem: mensagem, user: user, funcao: :controlador,
       reuniao: self, destinatario: self.controlador)
      if !convite_controlador.nil?
        convite_controlador.cancelar("Troca de controlador")
        convite_controlador.save
      end
    end

    convites_participantes = self.convites_participantes
    participantes = []
    if convites_participantes.any?
      convites_participantes.each do |convite|
        participantes << convite.destinatario
      end
    end

    if self.participantes.nil?
      self.participantes = []
    end

    self.participantes.delete(self.coordenador)
    self.participantes.delete(self.redator)
    
    if(!self.controlador.nil?)
      self.participantes.delete(self.controlador)
    end  
    
    participantes_adicionados = self.participantes - participantes
    participantes_removidos = participantes - self.participantes

    participantes_adicionados.each do |participante|
      convites << Convite.create(mensagem: mensagem, user: user, funcao: :participante,
        reuniao: self, destinatario: participante)
    end

    participantes_removidos.each do |participante|
      convites_participantes.each do |convite|
        if convite.destinatario == participante
          convite.cancelar("Remoção de participante")
          convite.save
        end
      end
    end

    convites_convidados = self.convites_convidados
    convidados = []
    if convites_convidados.any?
      convites_convidados.each do |convite|
        convidados << convite.destinatario
      end
    end

    if self.convidados.nil?
      self.convidados = []
    end

    convidados_adicionados = self.convidados - convidados
    convidados_removidos = convidados - self.convidados
    convidados_adicionados.each do |convidado|
      convites << Convite.create(mensagem: mensagem, user: user, funcao: :convidado,
        reuniao: self, destinatario: convidado)
    end

    convidados_removidos.each do |convidado|
      convites_convidados.each do |convite|
        if convite.destinatario == convidado
          convite.cancelar("Remoção de convidado")
          convite.save
        end
      end
    end

    self.convites = convites
  end

  def convites_participantes
    self.convites_with_funcao(:participante)
  end

  def convites_participantes_presentes
    self.convites_participantes.where("status = ?", 'Confirmado')
  end

  def convites_participantes_ausentes
    self.convites_participantes.where("status <> ?", 'Confirmado')
  end

  def convites_convidados
    self.convites_with_funcao(:convidado)
  end

  def convites_convidados_presentes
    self.convites_convidados.where("status = ?", 'Confirmado')
  end

  def convites_convidados_ausentes
    self.convites_convidados.where("status <> ?", 'Confirmado')
  end

  def convite_coordenador
    self.convites_with_funcao(:coordenador).last
  end
  
  def convite_redator
    self.convites_with_funcao(:redator).last
  end

  def convite_controlador
    self.convites_with_funcao(:controlador).last
  end

  def convites_with_funcao(funcao)
    self.convites.with_funcao(funcao).without_status(:cancelado)
  end

  def usuario_convidado?(usuario)
    self.convites.each do |convite|
      if convite.destinatario == usuario
        return true
      end
    end
    return false    
  end 

  def gerar_codigo
    data = Time.now
    self.codigo = "#{Reuniao.no_periodo(data, self.forum).count + 1}/#{data.year}"
  end

  private
    def relacionar_participantes    
      if !self.data.nil?
        self.data_hora = self.data.strftime("%H:%M")
      end

      self.redator = self.convite_redator.present? ? self.convite_redator.destinatario : self.evento.redator
      self.coordenador = self.convite_coordenador.present? ? self.convite_coordenador.destinatario : self.evento.coordenador
      self.controlador = self.convite_controlador.present? ? self.convite_controlador.destinatario : self.evento.controlador

      self.participantes = []
      self.convidados = []

      if self.convites_participantes.any?
        self.convites_participantes.each do |conv_participante|
          self.participantes << conv_participante.destinatario
        end
      else 
        self.participantes = self.evento.participantes.any? ? self.evento.participantes : self.forum.participantes
      end

      if self.convites_convidados.any?
        self.convites_convidados.each do |conv_convidado|
          self.convidados << conv_convidado.destinatario
        end
      end
    end
end

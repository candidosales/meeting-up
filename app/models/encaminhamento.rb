# == Schema Information
#
# Table name: encaminhamentos
#
#  id                  :integer          not null, primary key
#  status              :string(255)
#  descricao           :string(255)
#  assunto_id          :integer
#  created_at          :datetime
#  updated_at          :datetime
#  forum_id            :integer
#  reuniao_id          :integer
#  codigo              :string(255)
#  previsao            :date
#  data_conclusao      :datetime
#  pai_id              :integer
#  data_inicio         :datetime
#  homologado          :boolean          default(FALSE)
#  data_homologacao    :datetime
#  previsao_antiga     :date
#  previsao_solicitada :date
#  emailed             :boolean          default(FALSE)
#

class Encaminhamento < ActiveRecord::Base
	extend Enumerize
	include Situable

	validates_presence_of :descricao, :previsao, :users, :assunto, :forum

	has_and_belongs_to_many :users
	has_many :notas, -> {order 'created_at DESC'}, as: :notable
	belongs_to :assunto
	belongs_to :forum
	belongs_to :reuniao

	has_many :situacoes, -> { order 'data DESC' }, as: :situable

	has_many :lembretes, as: :lembrable

	belongs_to :pai, class_name: "Encaminhamento", :foreign_key => "pai_id"
	has_many :encs_filhos, class_name: "Encaminhamento",
                          foreign_key: "pai_id"


    has_many :documentos, as: :documentable

	before_validation :gerar_codigo, on: :create
	# before_validation :validar_data

	enumerize :status, in: {:andamento => 'E/A', :cancelado => 'CNL', :pausado => 'PA',
		:nao_iniciado => 'N/I', :concluido =>'CON', :novo_prazo => 'N/P', :solicitado_adiamento => 'S/A'}, 
		default: :nao_iniciado, predicates: true,  scope: true

	scope :no_periodo, -> (data, forum) {where(:created_at => data.beginning_of_year.. data.end_of_year,
			:forum => forum)}

	scope :previsao_inicio, -> (previsao) { where("previsao >= ? ", previsao)}
	scope :previsao_fim, -> (previsao) { where("previsao <= ? ", previsao)}
	scope :por_codigo, -> (codigo) { where("codigo = ?", codigo) }

	scope :permitido, ->(forum, usuario) do

	    if forum.coordenador == usuario
	      where("forum_id = :f", f: forum)
	    else
	      joins(:users)
	      .where('encaminhamentos_users.user_id = :u and forum_id = :f', u: usuario, f: forum)
	      .readonly(false).order(:id).distinct
	    end

	end

	scope :do_usuario, ->(usuario) {joins(:users).where('encaminhamentos_users.user_id = :u', u: usuario)
	      .readonly(false).order(:id).distinct}

	validates_inclusion_of :homologado, :in => [true, false]
	
	def gerar_codigo
		data = Time.now
		self.codigo = "#{Encaminhamento.no_periodo(data, self.forum).count + 1}/#{data.year}"
	end

	def to_s
	  descricao
	end

  def criar_situacao_inicial (usuario)
    criar_situacao(self, self.status_text, "Definição de encaminhamento", usuario)
  end

  def enviar_notificacao(tipo)
    NotificacaoMailer.delay.send(tipo, self, self.forum.coordenador)
  end

  def notificar_usuarios
  	users.each do |u|
  		 NotificacaoMailer.delay.send(:novo_encaminhamento, self, u)
  	end
  	self.emailed = true
  	self.save
  end	

  def iniciar(user) 
  	self.status = :andamento
  	criar_situacao(self, self.status_text, "Inicio das atividades", user)
  end

  def cancelar (motivo, user)
  	self.status = :cancelado
  	criar_situacao(self, self.status_text, motivo, user)
  end

  def pausar(motivo, user)
	self.status = :pausado
  	criar_situacao(self, self.status_text, motivo, user)
  end

  def concluir(data_conclusao, user)
  	self.status = :concluido
  	self.data_conclusao = data_conclusao
  	criar_situacao(self, self.status_text, "Conclusão da tarefa", user)
  end

  def homologar(homologado, user)
  	self.data_homologacao = Time.now
  	self.homologado = homologado
  	criar_situacao(self, "Homologado", "Homologação da tarefa", user)
  end

  def esta_atrasado?
  	!concluido? && (self.previsao.nil? || Time.now.to_date > self.previsao)
  end

  def homologar_pai
	if self.pai.present? && self.pai.tem_encaminhamentos_pendentes?
		self.pai.homologado = true
		self.pai.save
		self.pai.homologar_pai
	end
  end

  def solicitar_adiamento(user)
  	self.enviar_notificacao(:solicitar_adiar_encaminhamento)
  	self.status = :solicitado_adiamento
  	criar_situacao(self, "Solicitado Adiamento", "Solicitação de adiamento", user)
  	self.save
  end

  def adiar(user)
  	self.status = :nao_iniciado
  	criar_situacao(self, "Adiamento Confirmado", "Confirmação de adiamento", user)
  	self.save
  end	

  def tem_encaminhamentos_pendentes?
	self.encs_filhos.each do |e| 
      if !e.status.concluido? || !e.homologado
        return true
      end
    end
    return false
  end


	# def validar_data
	# 	DateTime.strptime(previsao, "%d/%m/%Y %H:%M")
	# rescue
	# 	errors.add :previsao, :invalid
	# end
end

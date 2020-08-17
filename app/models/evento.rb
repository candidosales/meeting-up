# == Schema Information
#
# Table name: eventos
#
#  id               :integer          not null, primary key
#  titulo           :string(255)
#  data_inicial     :datetime
#  data_final       :datetime
#  forum_id         :integer
#  coordenador_id   :integer
#  redator_id       :integer
#  controlador_id   :integer
#  created_at       :datetime
#  updated_at       :datetime
#  local_id         :integer
#  periodicidade_id :integer
#  status           :string(255)
#  user_id          :integer
#

class Evento < ActiveRecord::Base
  extend Enumerize
  include Situable

  validates_presence_of :data_inicial_dia, :data_final_dia, :data_inicial_hora, :data_final_hora, :titulo, :forum, :redator, :coordenador
  before_validation :set_datetimes
  validate :data_validate
  after_initialize :get_datetimes #

  belongs_to :forum
  belongs_to :local
  belongs_to :redator,  class_name: "User"
  belongs_to :controlador,  class_name: "User"
  belongs_to :coordenador,  class_name: "User"
  # usuario q criou o evento
  belongs_to :user

  belongs_to :periodicidade
  accepts_nested_attributes_for :periodicidade
  
  has_and_belongs_to_many :participantes, class_name: "User"

  has_many :reunioes
  
  # um evento tem assuntos através de reuniões
  # has_many :assuntos, through: :reunioes
  has_and_belongs_to_many :assuntos

  has_many :situacoes, -> { order 'data DESC' }, as: :situable
  has_many :lembretes, as: :lembrable
  
  accepts_nested_attributes_for :lembretes, :allow_destroy => true

  enumerize :status, in: {:agendado => 'A', :cancelado => 'C', :realizado => 'R'}, 
    default: :agendado, predicates: true, scope: true

  scope :cancelaveis,  ->(time) { where(" data_final >= ? and status = 'A'", time) }

  attr_accessor :data_inicial_dia, :data_inicial_hora, :data_final_dia, :data_final_hora
  

  def set_datetimes
    self.data_inicial = "#{self.data_inicial_dia} #{self.data_inicial_hora}:00" # converte os dois campos pro formato datetime
    self.data_final = "#{self.data_final_dia} #{self.data_final_hora}:00" # converte os dois campos pro formato datetime
  end

  def get_datetimes
    self.data_inicial ||= Time.now
    self.data_final||= Time.now

    self.data_inicial_dia ||= self.data_inicial.strftime('%d/%m/%Y')
    self.data_inicial_hora ||= "#{'%02d' % self.data_inicial.hour}:#{'%02d' % self.data_inicial.min}"

    self.data_final_dia ||= self.data_final.strftime('%d/%m/%Y')
    self.data_final_hora ||= "#{'%02d' % self.data_final.hour}:#{'%02d' % self.data_final.min}"
  end 

  def data_validate
    errors.add(:data_inicial_dia, "deve ser menor que o fim do periodo.") if
      !(self.data_inicial_dia.blank? or self.data_final_dia.blank?) && (self.data_inicial > self.data_final)

    if (self.periodicidade.repeticao.nil? && !(self.data_inicial_dia.blank? or self.data_final_dia.blank?) && (self.data_inicial.to_date != self.data_final.to_date))
       raise "A data inicial e final devem ser igual pois não foi informada uma periodicidade." 
    end

    if(!periodicidade.repeticao.nil? and !periodicidade.frequencia.nil? and (periodicidade.repete_cada.nil? or periodicidade.repete_cada == 0) )
      raise "O campo 'Repete a cada' deve ser informado" 
    end  

  end

  def cancelar (motivo, user)
    self.status = :cancelado
    criar_situacao(self, self.status_text, motivo, user)
    self.reunioes.each do |reuniao|
      if (reuniao.agendada?)
        reuniao.cancelar(motivo, user)
      end
    end

  end

  def criar_situacao_agendada
    if (valid?)
      criar_situacao(self, self.status_text, "Agendamento da reunião", self.user)
    end
  end

  
  def criar_reuniao(user)
    tipo = 0 ;
    if (self.data_final.yday > self.data_inicial.yday )
      tipo = 1
    else
      tipo = 2
    end

    data_proxima = self.data_proxima_reuniao(nil)
    if !data_proxima.nil?
      assuntos = self.reunioes.size > 0 ? [] : self.assuntos
      r = Reuniao.create(forum: self.forum, assuntos: assuntos, local: self.local,
        data: data_proxima, evento: self, titulo: self.titulo, tipo: tipo)
   
      if (r.valid?)
          r.coordenador = self.coordenador
          r.redator = self.redator
          r.controlador = self.controlador
          r.participantes = self.participantes
          r.criar_convites("Convite durante agendamento de reunião.", user)
          
          r.criar_situacao_agendada(user)

          self.reunioes << r
          r.enviar_notificacao(:nova_reuniao)
      end
      
      return r
    end
  end

  def data_proxima_reuniao(reuniao_base)

    mensal = false 
    # self.periodicidade.mensal?
    semanal = self.periodicidade.semanal?
    anual = false
    # self.periodicidade.anual?
    hoje = Time.now.to_date

    dt_inicial = self.data_inicial.to_date
    # se a data atual for maior que a data final do evento, não tem mais proxima
    if hoje > self.data_final.to_date
      return nil
    end

    # se a data inicial e final do evento são iguais, então só tem uma reunião e a data é sempre a inicial
    if (dt_inicial == self.data_final.to_date)
      return "#{dt_inicial} #{self.data_inicial_hora}:00"
    end
    
    repete = self.periodicidade.repete_cada

    if reuniao_base.nil?
      ultima_reuniao = self.reunioes.last.nil? ? nil : self.reunioes.last.data.to_date
    else
      ultima_reuniao = reuniao_base.data.to_date
    end    

    proxima = nil
    base = nil

    is_ultima = false
    is_primeira = false
    # usar a ultima reunião com base ou a data inicial
    if ultima_reuniao.nil?
      base = dt_inicial
      is_primeira = true
    else
      base = ultima_reuniao
      is_ultima = true
    end

    if mensal
      if self.periodicidade.dia_mes?
        day = base.day
        puts "DAY OF #{day}  eq  #{hoje>base} base #{base}"
         
        if (is_primeira && hoje.month > base.month)
          proxima = base.change(day: day) + 1.month
        else
          proxima = base.change(day: day)
        end

        if (is_ultima)
           proxima += (repete > 0 ? (repete * 1).month : 1.month)
        end
      end
    end

    periodicidade_selecionada = nil
    primeira_periodicidade = self.periodicidade.frequencia.values.first
    dia_da_semana = base.days_past_in_week
    values_periodicidade = Periodicidade.frequencia.values
    self.periodicidade.frequencia.values.each do |per|
      if dia_da_semana < values_periodicidade.index(per) && periodicidade_selecionada.nil?
        periodicidade_selecionada = per
        break
      end 
    end

    if periodicidade_selecionada.nil?
      periodicidade_selecionada = primeira_periodicidade
    end

    if semanal
      if periodicidade_selecionada.segunda? 
        if  base.monday? && is_primeira
          return "#{base} #{self.data_inicial_hora}:00"
        else
          proxima = base.upcoming_monday
        end
      end
      if periodicidade_selecionada.terca? 
        if  base.tuesday? && is_primeira
          return "#{base} #{self.data_inicial_hora}:00"
        else
          proxima = base.upcoming_tuesday
        end
      end
      if periodicidade_selecionada.quarta? 
        if  base.wednesday? && is_primeira
          return "#{base} #{self.data_inicial_hora}:00"
        else
          proxima = base.upcoming_wednesday
        end
      end
      if periodicidade_selecionada.quinta? 
        if  base.thursday? && is_primeira
          return "#{base} #{self.data_inicial_hora}:00"
        else
          proxima = base.upcoming_thursday
        end
      end
      if periodicidade_selecionada.sexta? 
        if  base.friday? && is_primeira
          return "#{base} #{self.data_inicial_hora}:00"
        else
          proxima = base.upcoming_friday
        end
      end
      if periodicidade_selecionada.sabado? 
        if  base.saturday? && is_primeira
          return "#{base} #{self.data_inicial_hora}:00"
        else
          proxima = base.upcoming_saturday
        end
      end
      if periodicidade_selecionada.domingo? 
        if  base.sunday? && is_primeira
          return "#{base} #{self.data_inicial_hora}:00"
        else
          proxima = base.upcoming_sunday
        end
      end

      if is_ultima && periodicidade_selecionada == primeira_periodicidade
        proxima += (repete > 0 ? ((repete - 1) * 7).days : 0)    
      end
    end

    if anual
      if is_primeira
        return "#{base} #{self.data_inicial_hora}:00"
      else
        if is_ultima
        proxima += (repete > 0 ? (repete * 1).year : 0)    
        end
      end
    end

    if (proxima > self.data_final.to_date)
      return nil
    end
    
    return "#{proxima} #{self.data_inicial_hora}:00"
  end

end

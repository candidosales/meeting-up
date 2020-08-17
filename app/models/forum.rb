# == Schema Information
#
# Table name: foruns
#
#  id             :integer          not null, primary key
#  nome           :string(255)
#  coordenador_id :integer
#  created_at     :datetime
#  updated_at     :datetime
#  sigla          :string(255)
#  descricao      :text
#  pai_id         :integer
#

class Forum < ActiveRecord::Base

  validates_uniqueness_of :sigla	
  validates_presence_of :nome, :sigla, :descricao, :coordenador
  validate :validar_participantes

  belongs_to :coordenador, class_name: "User"
  belongs_to :pai, class_name: "Forum", :foreign_key => "pai_id"

  has_and_belongs_to_many :participantes, class_name: "User"

# nested resource
  has_many :eventos
  has_many :assuntos
  has_many :reunioes
  has_many :encaminhamentos
  
  has_many :forunsFilhos, class_name: "Forum",
                          foreign_key: "pai_id"
 
  scope :por_nome, -> (nome) { where("nome ilike ?", "%#{nome}%") }

  scope :por_coordenador, -> (id_user) { where("coordenador_id = ?", id_user) }

  scope :por_forum_pai, -> (id_forum) { where("pai_id = ?", id_forum) }

  scope :acessiveis, ->(usuario) do 
    if usuario.is_a? Admin
      all
    else
      joins(:participantes, :coordenador, 'left join "foruns" "pais_foruns" ON "pais_foruns"."id" = "foruns"."pai_id"')
      .where('foruns.coordenador_id=:u or user_id=:u or pais_foruns.coordenador_id = :u', u: usuario)
      .readonly(false).order(:id).distinct
    end
    
  end

  scope :assuntos_internos_externos, -> (forum) {Assunto.where("forum_destino_id = ? or forum_id = ?", forum, forum)}

  def atualizar_filhos (forum)
  	self.forunsFilhos << forum
  end

  def validar_participantes
    if self.participantes.include? self.coordenador
      errors.add(:coordenador, "não pode ser adicionado como participante pois já é coordenador.")
    end
  end

  # def to_param
  #   "#{self.id}-#{sigla}"
  # end
end

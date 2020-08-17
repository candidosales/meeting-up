# == Schema Information
#
# Table name: assuntos
#
#  id                   :integer          not null, primary key
#  descricao            :string(255)
#  detalhamento         :text
#  resumo               :text
#  decisao              :text
#  discutido            :boolean
#  created_at           :datetime
#  updated_at           :datetime
#  categoria_id         :integer
#  arquivo_file_name    :string(255)
#  arquivo_content_type :string(255)
#  arquivo_file_size    :integer
#  arquivo_updated_at   :datetime
#  forum_id             :integer
#  usuario_id           :integer
#  prioridade           :integer
#  forum_destino_id     :integer
#  status               :integer
#  situacoes_id         :integer
#  data_conclusao       :datetime
#  pai_id               :integer
#  file                 :string(255)
#

class Assunto < ActiveRecord::Base
	extend Enumerize
  include Situable

  belongs_to :forum
  belongs_to :forum_destino, class_name: "Forum"
  belongs_to :usuario, class_name: "User"
  
  has_and_belongs_to_many :reunioes

  # temporário
  has_and_belongs_to_many :eventos

  belongs_to :categoria, :foreign_key => "categoria_id"

  enumerize :prioridade, in: {:alta => 1, :media => 2, :baixa => 3}, predicates: true, scope: true

  has_many :situacoes, -> { order 'data DESC' }, as: :situable

  enumerize :status, in: {:nao_discutido => 1, :andamento => 2, :concluido => 3},
    default: :nao_discutido, predicates: true, scope: true

  has_many :notas, ->{ order 'created_at desc' }, as: :notable
  has_many :encaminhamentos, ->{ order 'created_at desc' }

  belongs_to :pai, class_name: "Assunto", :foreign_key => "pai_id"
  has_many :assuntos_filhos, class_name: "Assunto",
                          foreign_key: "pai_id"

  # has_attached_file :arquivo,
  #   :path => '/home/files/:class/:id-:basename.:extension',
  #   :url => '/home/files/:class/:id-:basename.:extension'
  
  # validates_attachment_file_name :arquivo, :matches => %r{\.(docx|doc|pdf|jpg|png|xls|xlsx|odt|txt|mpeg|avi|mp4)\z}i

  mount_uploader :file, FileUploader
  
  validates_presence_of :descricao, :prioridade, :forum, :forum_destino
  validates_length_of :descricao, :minimum => 2

  scope :por_descricao, -> (desc) { where("descricao ilike ?", "%#{desc}%") }

  scope :por_forum_origem, -> (id_forum) { where("forum_id = ?", id_forum) }

  scope :por_forum_destino, -> (id_forum) { where("forum_destino_id = ?", id_forum) }

  scope :interno, ->(forum) {
    where("forum_id = :f and forum_destino_id = :f", :f => forum)
  }

  scope :externo, ->(forum) {
    where("forum_id <> :f and forum_destino_id = :f", :f => forum)
  }

  scope :encaminhados, ->(forum) {
    where("forum_id = :f and forum_destino_id <> :f", :f => forum)
  }

  scope :disponiveis, -> {where("discutido is false")}

  
  def criar_situacao_inicial (usuario)
    criar_situacao(self, self.status_text, "Proposta de assunto", usuario)
  end

  def definir_situacao_encerrar_reuniao (usuario)
    if (self.notas.any?)
      if (self.tem_encaminhamentos_pendentes? || self.tem_assuntos_pendentes?)
        if !self.status.andamento?
          self.status = :andamento
          criar_situacao(self, self.status_text, "Assunto com encaminhamentos pendentes.", usuario)
        end
      else
        concluir(usuario)

        if !self.pai.nil?
          self.pai.definir_situacao_encerrar_reuniao(usuario)
          if self.pai.status.concluido?
            self.pai.save
          end
        end

      end
    end
  end

  def concluir (usuario)
    if !self.status.concluido?
      self.status = :concluido
      self.data_conclusao = DateTime.now
      criar_situacao(self, self.status_text, "Conclusão do assunto.", usuario)
    end
  end

  def to_s
    descricao
  end

  def tem_encaminhamentos_pendentes?
    self.encaminhamentos.each do |e| 
      if !e.status.concluido? || !e.homologado
        return true
      end
    end
    return false
  end

  def tem_assuntos_pendentes?
    self.assuntos_filhos.each do |e| 
      if !e.status.concluido?
        return true
      end
    end
    return false
  end
    

end

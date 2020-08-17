# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  cargo_id               :integer
#  nome                   :string(255)
#  matricula              :string(255)
#  cpf                    :string(255)
#  empresa_id             :integer
#  data_nascimento        :date
#  avatar_file_name       :string(255)
#  avatar_content_type    :string(255)
#  avatar_file_size       :integer
#  avatar_updated_at      :datetime
#  tipo                   :string(255)
#  qualificacao           :text
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  setor_id               :integer
#  ativo                  :boolean          default(FALSE)
#

class User < ActiveRecord::Base
  extend Enumerize

  has_attached_file :avatar,
    :styles => { :medium => "300x300>", :thumb => "100x100>", :mini => "30x30>" },
    :path => ':rails_root/public/images/:class/:id-:basename-:style.:extension',
    :url => '/images/:class/:id-:basename-:style.:extension',
    :default_url => ActionController::Base.helpers.asset_path("avatar-:style.png")

  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  devise :database_authenticatable, :registerable, :async,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable,
         :authentication_keys => [:login], :confirmation_keys => [:login], 
         :reset_password_keys => [:login]

  validates_format_of :email, :with => /\A[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}\z/i

  validates :matricula, :uniqueness => {:case_sensitive => false}, :if => lambda { |u| !u.matricula.blank?}
  validates_presence_of :matricula, :if => lambda { |u| u.normal?}

  belongs_to :cargo
  belongs_to :setor
  belongs_to :empresa 
  has_and_belongs_to_many :foruns   

  has_and_belongs_to_many :reunioes
  has_and_belongs_to_many :encaminhamentos
  validates_presence_of :password, on: :update, :if => lambda { |u| !u.confirmed?}
  validates :cpf, cpf: true, on: :update
  has_many :convites

  enumerize :tipo, in: {convidado: 'C', normal: 'N'}, default: :normal, predicates: true, scope: true

  scope :tipo, ->(tipo) { where(tipo: tipo) }

  scope :forum, -> (forum) { where(forum: forum) }

  scope :por_nome, -> (nome) { where("nome ilike ?", "%#{nome}%") }

  scope :por_email, -> (email) { where("email = ?", email) }
  # Virtual attribute for authenticating by either matricula or email
  # This is in addition to a real persisted field like 'matricula'
  attr_accessor :login  

  def to_s
    nome || email
  end

  def first_name
    nome = self.nome
    if nome.presence
      nomes = nome.split(' ')
      nome = nomes.presence ? nomes[0] : nome
    end
    nome
  end

#### This is the correct method you override with the code above
#### Isso permite entrar no sistema usando a matícula ou email
#### def self.find_for_database_authentication(warden_conditions)
#### end  
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(matricula) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

### Essas instruções foram encontradas no link https://github.com/plataformatec/devise/wiki/How-To:-Require-admin-to-activate-account-before-sign_in
#### Evitar que usuários convidados consigam logar no sistema
  def active_for_authentication? 
    super && !self.convidado? && self.ativo
  end 

  def inactive_message 
    if self.convidado? 
      :not_approved 
    else 
      super # Use whatever other message 
    end 
  end  

#### Reset password instructions
  def self.send_reset_password_instructions(attributes={})
    recoverable = find_or_initialize_with_errors(reset_password_keys, attributes, :not_found)
    if recoverable.convidado?
      recoverable.errors[:base] << I18n.t("devise.failure.not_approved")
    elsif recoverable.persisted?
      recoverable.send_reset_password_instructions
    end
    recoverable
  end

#### Confirmation message instructions
 # Send confirmation instructions by email
  def send_confirmation_instructions
    if !self.convidado? && !self.ativo
      super
    end
  end

  def send_confirmation_notification?
    super && !self.convidado?
  end  

  # new function to set the password without knowing the current password used in our confirmation controller. 
  def attempt_set_password(params)
    p = {}
    p[:password] = params[:password]
    p[:password_confirmation] = params[:password_confirmation]
    update_attributes(p)
  end

  # new function to return whether a password has been set
  def has_no_password?
    self.encrypted_password.blank?
  end  

  def only_if_unconfirmed
    pending_any_confirmation {yield}
  end

  protected
  def password_required?
    password.present? || password_confirmation.present?
  end
end

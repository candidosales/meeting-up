# == Schema Information
#
# Table name: empresas
#
#  id                :integer          not null, primary key
#  nome              :string(255)
#  cnpj              :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#  logo_file_name    :string(255)
#  logo_content_type :string(255)
#  logo_file_size    :integer
#  logo_updated_at   :datetime
#

class Empresa < ActiveRecord::Base
	
  has_attached_file :logo, :styles => { :medium => "300x300>", :thumb => "100x100>" }, 
    :path => ':rails_root/public/images/:class/:id-:basename-:style.:extension',
    :url => '/images/:class/:id-:basename-:style.:extension'

  validates_attachment_content_type :logo, :content_type => /\Aimage\/.*\Z/

	# has_one :endereco, class_name: "Endereco::Endereco"
  has_many :colaboradores, class_name: "User"
  validates :cnpj, cnpj: true

end

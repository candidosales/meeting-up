# == Schema Information
#
# Table name: documentos
#
#  id                :integer          not null, primary key
#  created_at        :datetime
#  updated_at        :datetime
#  arquivo           :binary
#  documentable_id   :integer
#  documentable_type :string(255)
#  file              :string(255)
#

class Documento < ActiveRecord::Base
	
	belongs_to :documentable, polymorphic: true
	
	mount_uploader :file, FileUploader
     
end

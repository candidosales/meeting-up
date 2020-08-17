# == Schema Information
#
# Table name: situacoes
#
#  id            :integer          not null, primary key
#  descricao     :string(255)
#  motivo        :text
#  user_id       :integer
#  data          :datetime
#  created_at    :datetime
#  updated_at    :datetime
#  situable_id   :integer
#  situable_type :string(255)
#

class Situacao < ActiveRecord::Base
  belongs_to :user
  belongs_to :situable, polymorphic: true

end

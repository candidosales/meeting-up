# == Schema Information
#
# Table name: lembretes
#
#  id             :integer          not null, primary key
#  tipo           :string(255)
#  intervalo      :integer          default(1)
#  periodo        :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  lembrable_id   :integer
#  lembrable_type :string(255)
#  enviado        :boolean          default(FALSE)
#

class Lembrete < ActiveRecord::Base
	extend Enumerize

	belongs_to :lembrable, polymorphic: true
	#validates_numericality_of :intervalo, greater_than: 0

	# add SMS, pop-up depois
	enumerize :tipo, in: {:email => 'E'}, default: :email, predicates: true
	enumerize :periodo, in: {:minutos => 'M', :horas => 'H', :dias => 'D', :semanas => 'S' }, 
		 predicates: true

end

# == Schema Information
#
# Table name: compartilhamentos
#
#  id         :integer          not null, primary key
#  reuniao_id :integer
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Compartilhamento < ActiveRecord::Base
  belongs_to :reuniao

  validates_presence_of :reuniao_id, :email
end

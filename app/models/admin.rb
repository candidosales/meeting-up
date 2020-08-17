# == Schema Information
#
# Table name: admins
#
#  id                 :integer          not null, primary key
#  nome               :string(255)
#  email              :string(255)      default(""), not null
#  encrypted_password :string(255)      default(""), not null
#  sign_in_count      :integer          default(0)
#  current_sign_in_at :datetime
#  last_sign_in_at    :datetime
#  current_sign_in_ip :string(255)
#  last_sign_in_ip    :string(255)
#  failed_attempts    :integer          default(0)
#  unlock_token       :string(255)
#  locked_at          :datetime
#  created_at         :datetime
#  updated_at         :datetime
#

class Admin < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :trackable, :timeoutable, :lockable, :validatable, :registerable,
  		:authentication_keys => [:email]
end

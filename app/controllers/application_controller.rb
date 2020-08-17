require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters

    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email,
    	:password, :password_confirmation, :nome, :cargo_id, :setor_id, :matricula, :cpf, :data_nascimento, :avatar, :tipo,:qualificacao) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :matricula, :email, :password, :remember_me) }    
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:email,
      :password, :password_confirmation, :current_password, :nome, :cargo_id, :setor_id, :matricula, :cpf, :data_nascimento, :avatar, :tipo,:qualificacao) }
  end

  def after_sign_in_path_for(resource)
    foruns_path
  end

  def authenticate_any!
    if admin_signed_in?
        true
    else
        authenticate_user!
    end
  end  

end

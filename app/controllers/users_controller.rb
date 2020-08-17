class UsersController < ApplicationController
  respond_to :html, :js

  before_filter :authenticate_any!
  before_action :set_user, only: [:show, :edit, :update, :reenviar_email_confirmacao, :mudar_status]

  has_scope :por_nome
  has_scope :por_email

  def index
    @users = apply_scopes(resource_base).order(:id).page params[:page]
    respond_with(@users)
  end

  def show
    respond_with(@user)
  end

  def new
    @user = resource_base.new
    respond_with(@user)
  end

  def create
    @user = resource_base.create(user_params)
    respond_with (@user)
  end

  def edit
    respond_with (@user)
  end

  def update
    @user.update_attributes(user_params)
    respond_with(@user, :location => @user)
  end

  def reenviar_email_confirmacao
    message = ""
    if @user.confirmed_at.nil?
      @user.send_confirmation_instructions
      message = "Email enviado!"
    else
      message = "Não foi possível reenviar o email porque o usuário já está confirmado!"
    end
    respond_with(@user, :notice => message)
  end

  def mudar_status
    ativar = params[:user][:status]
    message = {}
    if ativar == 0
      foruns_coordenadores = []
      foruns = Forum.all
      foruns.each do |forum|
        if forum.coordenador == @user
          foruns_coordenadores << forum.nome
        end
      end
      if foruns_coordenadores.empty?
        @user.update_attributes({:ativo => false})
        foruns.each do |forum|
          forum.participantes.delete(@user)
        end

        Evento.where("data_final > :hoje", :hoje => Time.now).each do |evento|
          if evento.coordenador == @user
            evento.update_attribute(:coordenador, nil)
          end

          if evento.controlador == @user
            evento.update_attribute(:controlador, nil)
          end

          if evento.redator == @user
            evento.update_attribute(:redator, nil)
          end

          evento.participantes.delete(@user)
          
        end

        convites = Convite.joins(:reuniao).where("destinatario_id = :user and reunioes.status in ('A','CO')", :user => @user.id).readonly(false)
        convites.each do |convite| 
          convite.cancelar("Inativação do usuário")
          convite.save          
        end

        flash[:notice] = "Usuário inativado com sucesso"
      else
        flash[:error] = "Usuário não pode ser inativado, pois é coordenador dos seguintes fóruns: #{foruns_coordenadores.to_sentence}"
      end
    elsif ativar == 1
      @user.update_attributes({:ativo => true})
      flash[:notice] = "Usuário ativado com sucesso"
    end

    redirect_to users_path
  end

  private
    def resource_base
      params[:tipo].blank? ? User : User.tipo(params[:tipo])
    end

    def set_user
    	@user = resource_base.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:email,:nome, :password, :password_confirmation,
       :qualificacao, :avatar, :cargo_id, :setor_id, :matricula, :cpf, :data_nascimento, :tipo)
    end
end

class ConvitesController < ApplicationController
  respond_to :html, :js

  before_action :set_convite, only: [:show, :confirmar, :new_recusar, :recusar, :chamada]

  def index
    @convites = Convite.permitido(current_user).all
    respond_with(@convites)
  end

  def show
    respond_with(@convite)
  end	

  def chamada
    @convite.update_attributes(params_convite)
    respond_with(@convite)
  end

  def confirmar
    @convite.confirmar
    if @convite.save
       redirect_to convite_path(@convite), :notice => "Convite confirmado com sucesso!"
    end
  end

  def new_recusar
    respond_with(@convite)
  end  

  def recusar
    @convite.recusar(params[:new_recusar][:motivo])
    if @convite.save
      redirect_to convite_path(@convite), :notice => "Convite recusado com sucesso!"
    end  
  end

  private
  def set_convite
     @convite = Convite.find(params[:id])
  end

  def params_convite
    params.require(:convite).permit(:status, :data_recusa, :data_confirmacao)
  end

end

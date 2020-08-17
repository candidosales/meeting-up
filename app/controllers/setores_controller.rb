class SetoresController < ApplicationController
  
  before_filter :authenticate_admin!
  before_action :set_setor, only: [:show, :edit, :update, :destroy]

  has_scope :por_descricao

  def index
    @setores = apply_scopes(Setor).page params[:page]
    respond_with(@setores)
  end

  def show
    respond_with(@setor)
  end

  def new
    @setor = Setor.new
    respond_with(@setor)
  end

  def edit
    respond_with(@setor)
  end

  def create
    @setor = Setor.create(setores_params)
    respond_with(@setor, :location => @setor)
  end

  def update
    @setor.update_attributes(setores_params)
    respond_with(@setor, :location => @setor)
  end

  private
    def set_setor
      @setor = Setor.find(params[:id])
    end

    def setores_params
       params.require(:setor).permit(:descricao)
    end

end

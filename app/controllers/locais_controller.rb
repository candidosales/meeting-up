class LocaisController < ApplicationController
  
  before_filter :authenticate_admin!
  before_action :set_local, only: [:show, :edit, :update, :destroy]

  has_scope :por_descricao
  
  def index
    @locals = apply_scopes(Local).page params[:page]
    respond_with(@locals)
  end

  def show
    respond_with(@local)
  end

  def new
    @local = Local.new
    respond_with(@local)
  end

  def edit
    respond_with(@local)
  end

  def create
    @local = Local.create(local_params)
    respond_with(@local, :location => @local)
  end

  def update
    @local.update_attributes(local_params)
    respond_with(@local, :location => @local)
  end

  private
    def set_local
      @local = Local.find(params[:id])
    end

    def local_params
       params.require(:local).permit(:descricao)
    end
end

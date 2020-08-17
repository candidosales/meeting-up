class EmpresasController < ApplicationController

  before_filter :authenticate_admin!
  before_action :set_empresa, only: [:show, :edit, :update, :destroy]

  def index
    @empresas = Empresa.all
    respond_with(@empresas)
  end

  def show
    respond_with(@empresa)
  end

  def new
    @empresa = Empresa.new
    respond_with(@empresa)
  end

  def edit
    respond_with(@empresa)
  end

  def create
    @empresa = Empresa.create(empresas_params)
    respond_with(@empresa, :location => @empresa)
  end

  def update
    @empresa.update_attributes(empresas_params)
    respond_with(@empresa, :location => @empresa)
  end

  private
    def set_empresa
      @empresa = Empresa.find(params[:id])
    end

    def empresas_params
      params.require(:empresa).permit(:nome, :cnpj, :logo)
    end
end

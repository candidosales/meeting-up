class CargosController < ApplicationController

  before_filter :authenticate_admin!
  before_action :set_cargo, only: [:show, :edit, :update, :destroy]

  has_scope :por_descricao

  def index
    @cargos = apply_scopes(Cargo).page params[:page]
    respond_with(@cargos)
  end

  def show
    respond_with(@cargo)
  end

  def new
    @cargo = Cargo.new
    respond_with(@cargo)
  end

  def edit
    respond_with(@cargo)
  end

  def create
    @cargo = Cargo.create(cargo_params)
    respond_with(@cargo, :location => @cargo)
  end

  def update
    @cargo.update_attributes(cargo_params)
    respond_with(@cargo, :location => @cargo)
  end

  private
    def set_cargo
      @cargo = Cargo.find(params[:id])
    end

    def cargo_params
       params.require(:cargo).permit(:descricao)
    end
end

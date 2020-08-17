class CategoriasController < ApplicationController

  before_filter :authenticate_admin!
  before_action :set_categoria, only: [:show, :edit, :update, :destroy]

  has_scope :por_descricao
  has_scope :por_categoria_pai

  def index
    @categorias = apply_scopes(Categoria).page params[:page]
    respond_with(@categorias)
  end

  def show
    respond_with(@categoria)
  end

  def new
    @categoria = Categoria.new
    respond_with(@categoria)
  end

  def edit
    respond_with(@categoria)
  end

  def create
    @categoria = Categoria.create(params_categoria)
    respond_with(@categoria, :location => @categoria)
  end

  def update
    @categoria.update_attributes(params_categoria)
    respond_with(@categoria, :location => @categoria)
  end

  private
    def set_categoria
      @categoria = Categoria.find(params[:id])
    end

    def params_categoria
       params.require(:categoria).permit(:descricao, :categoria_pai_id)
    end

end

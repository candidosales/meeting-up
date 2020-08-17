class NotasController < ApplicationController
  respond_to :html, :js

  def create
    @nota = Nota.new(notas_params)
    @nota.usuario = current_user
    @nota.save
    respond_with(@nota)
  end

  def destroy
    @nota = Nota.find(params[:id])
    @nota.destroy
    respond_with(@nota)
  end

  private

  def notas_params
    params.require(:nota).permit(:descricao, :notable_id, :notable_type)
  end
end

class EventosController < ForumBaseController

  before_action :set_evento, only: [:show, :edit, :update, :destroy, :confirmar_cancelamento,
   :buscar_cancelar]

  def index
    @eventos = resource_base.eventos.all
    respond_with(@eventos)
  end

  def show
    respond_with(@evento)
  end

  def new
    @evento = resource_base.eventos.build
    @evento.participantes = @forum.participantes
    @evento.coordenador = @forum.coordenador
    @evento.periodicidade = Periodicidade.new

    @evento.lembretes.build

    respond_with(@forum, @evento)
  end

  def edit
    respond_with(@evento)
  end

  def create
    begin
      @evento = resource_base.eventos.create(param_evento)
      @evento.periodicidade.evento = @evento
      @evento.update(:user => current_user)
      @evento.criar_situacao_agendada

      if @evento.valid?
        @evento.criar_reuniao(current_user)
      end
      respond_with(@forum, @evento)
    rescue => e
      @evento = resource_base.eventos.new(param_evento)
      flash[:alert] = e.message
      render 'new'
    end
  end

  def update
    begin
      @evento.update_attributes(param_evento)
    rescue => e
      flash[:alert] = e.message
      render "edit" and return
    end
    redirect_to forum_eventos_path(@forum), :flash => {:notice => "Agendamento editado com sucesso." }
  end

  def buscar_cancelar
    respond_with(@forum, @evento)
  end

  def cancelar
    # buscar os eventos
    @eventos = resource_base.eventos.cancelaveis(DateTime.now.to_date)
    respond_with(@eventos)
  end

  def confirmar_cancelamento
    # passar o motivo
    @evento.cancelar(params[:buscar_cancelar][:motivo], current_user)
    @evento.save(:validate => false)
    respond_with(@forum, @evento)
  end

  private
    def set_evento
      @evento = resource_base.eventos.find(params[:id])
    end

    def param_evento
       params.require(:evento).permit(:titulo,  :data_inicial, :data_final, :data_inicial_dia,
        :data_inicial_hora, :data_final_dia, :data_final_hora, :local_id, :coordenador_id,
        :controlador_id, :redator_id, {:assunto_ids =>[]}, { :participante_ids =>[] }, 
        periodicidade_attributes: [:id, :repeticao, :repete_cada, :evento_id, :frequencia =>[] ],
        lembretes_attributes: [:id, :tipo, :intervalo, :periodo, :lembrable_id, :lembrable_type, :_destroy] )
    end

end

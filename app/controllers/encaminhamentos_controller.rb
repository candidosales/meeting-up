class EncaminhamentosController < ForumBaseController
  respond_to :html, :js

  before_filter :authenticate_user!
  has_scope :previsao_inicio 
  has_scope :previsao_fim 
  has_scope :with_status
  has_scope :por_codigo

  before_action :set_encaminhamento, only: [:show, :edit, :update, :destroy, 
    :adiar, :solicitar_adiar, :iniciar, :cancelar, :pausar, :concluir]

  def index
    @encaminhamentos = apply_scopes(Encaminhamento.permitido(resource_base, current_user))
      .order(id: :desc).page params[:page]
    respond_with(@encaminhamentos)
  end

  def show
    respond_with(@forum, @encaminhamento)
  end

  def new
    @encaminhamento = resource_base.encaminhamentos.build
    respond_with(@forum, @encaminhamento)
  end

  def edit
    respond_with(@encaminhamento)
  end

  def create
    @encaminhamento = resource_base.encaminhamentos.create(params_encaminhamento)
    if @encaminhamento.valid?
      @encaminhamento.criar_situacao_inicial(current_user)
    end
    respond_with(@forum, @encaminhamento)
  end

  def update
    @encaminhamento.update_attributes(params_encaminhamento)
    respond_with(@forum, @encaminhamento)
  end

  def solicitar_adiar
    if @encaminhamento.update(params_encaminhamento)
      @encaminhamento.solicitar_adiamento(current_user)
    end
    respond_with(@forum, @encaminhamento, notice: "A solicitação de adiamento foi realizada com sucesso")
  end

  def adiar
    if @encaminhamento.update(params_encaminhamento)
       @encaminhamento.adiar(current_user)
    end
    respond_with(@forum, @encaminhamento, notice: "Encaminhamento adiado com sucesso")
  end

  def iniciar
    if @encaminhamento.users.include?(current_user)
      @encaminhamento.iniciar(current_user)
      @encaminhamento.save
      return redirect_to forum_encaminhamento_path(@forum, @encaminhamento), :flash => { :notice => "Encaminhamento iniciado com sucesso" }  
    else 
      flash["error"] = "Somente uma pessoa designada pode iniciar o encaminhamento"
    end
    redirect_to forum_encaminhamento_path(@forum, @encaminhamento)

  end

  def pausar
    @encaminhamento.pausar(params[:pausar][:motivo], current_user)
    @encaminhamento.save
    redirect_to forum_encaminhamento_path(@forum, @encaminhamento), :flash => { :notice => "Encaminhamento pausado com sucesso" }  
  end

  def concluir
    @encaminhamento.concluir(Time.now, current_user)
    @encaminhamento.save
    
    redirect_to forum_encaminhamento_path(@forum, @encaminhamento), :flash => { :notice => "Encaminhamento concluido com sucesso" }
  end

  def cancelar
    @encaminhamento.cancelar(params[:cancelar][:motivo], current_user)
    @encaminhamento.save
    redirect_to forum_encaminhamento_path(@forum, @encaminhamento), :flash => { :notice => "Encaminhamento cancelado com sucesso" }
  end

  def destroy
    @encaminhamento.destroy
    respond_with(@forum, @encaminhamento)
  end

  def homologar
    @encaminhamento = resource_base.encaminhamentos.find(params[:id])
    if @encaminhamento.status.concluido?
      homolStr = params['encaminhamento']['homologado']
      homologado = homolStr == 'true' ? true : homolStr == 'false' ? false : nil
      if !homologado.nil?
          if (homologado != @encaminhamento.homologado || @encaminhamento.data_homologacao.nil?)
              if homologado && @encaminhamento.encs_filhos.any?
                flash.now[:error] = "Para aceitar a conclusão deste encaminhamento, você deve excluir todos os encaminhamentos redefinidos."
              else
                @encaminhamento.homologar(homologado, current_user)
                @encaminhamento.save
                if @encaminhamento.homologado
                  flash.now[:notice] = "A conclusão da tarefa foi aceita."
                else
                  flash.now[:notice] = "A conclusão da tarefa não foi aceita. Adicione novos encaminhamentos para identificar as pendências encontradas"
                end
              end
          end          
      else
        flash.now[:error] = "Valor inválido para homologação"
      end
    else
      flash.now[:error] = "Só encaminhamentos concluídos podem ser homologados."
    end
    
    respond_with(@forum, @encaminhamento)
  end

  private
    def set_encaminhamento
      @encaminhamento = resource_base.encaminhamentos.find(params[:id])
    end

    def params_encaminhamento
      params.require(:encaminhamento).permit(:descricao, :status, :previsao, :previsao_antiga, :previsao_solicitada, :assunto_id, :reuniao_id, :pai_id, :homologado, {:user_ids => []})
    end
end

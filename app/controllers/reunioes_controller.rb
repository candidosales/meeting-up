class ReunioesController < ForumBaseController
  respond_to :html, :js

  before_filter :authenticate_user!
  before_action :set_reuniao, only: [:show, :edit, :update, :destroy, :cancelar, :adiar,
    :add_remove_assuntos, :reativar, :confirmar, :confirmar_save, :iniciar, :encerrar,
    :ata, :compartilhar_ata]

  has_scope :data_inicio
  has_scope :data_fim
  has_scope :with_status

  def index
    @reunioes = apply_scopes(resource_base.reunioes).order(id: :desc).page params[:page]
    respond_with(@reunioes)
  end

  def show
    respond_with(@forum,@reuniao)
  end

  def new
    @reuniao = resource_base.reunioes.build
    respond_with(@forum, @reuniao)
  end

  def edit
    respond_with(@reuniao)
  end

  def create
    @reuniao = resource_base.reunioes.create(params_reuniao)
    @reuniao.update(:user => current_user)
    @reuniao.criar_situacao_agendada(current_user)
    respond_with(@forum, @reuniao)
  end

  def update
    if params[:reuniao][:assunto_ids].nil? || params[:reuniao][:assunto_ids].empty?
      flash.now["error"] = "Selecione pelo menos um assunto!"
      render "add_remove_assuntos"
    else
      @reuniao.update_attributes(params_reuniao)
      respond_with(@forum, @reuniao)
    end
  end

  def add_remove_assuntos
    @reuniao.save(:validate => false)
    respond_with(@forum, @reuniao)
  end

  def cancelar
    @reuniao.cancelar(params[:buscar_editar][:motivo], current_user)
    @reuniao.enviar_notificacao(:cancelar_reuniao)
    redirect_to forum_reunioes_path(@forum), :flash => { :notice => "Reunião cancelada com sucesso" }
  rescue
    redirect_to forum_reunioes_path(@forum), :alert => "Não foi possível cancelar a reunião"
  end

  def adiar
    begin
      
      @reuniao.validar_adiamento(params_reuniao[:data])
      @reuniao.assign_attributes(:data => params_reuniao[:data])
      @reuniao.save(:validate => false)
  
      @reuniao.enviar_notificacao(:adiar_reuniao)
      
      redirect_to forum_reunioes_path, notice: "Reunião adiada com sucesso."

    rescue => e
      flash.now[:alert] = e.message
      redirect_to forum_reunioes_path
    end

  end

  def reativar
    @reuniao.reativar(params[:buscar_reativar][:motivo], current_user)
    if @reuniao.save(:validate => false)
      @reuniao.enviar_notificacao(:reativar_reuniao)
    end
    redirect_to forum_reunioes_path(@forum), :flash => { :notice => "Reunião reativada com sucesso" }
  end

  def iniciar
    if @reuniao.coordenador == current_user || @reuniao.redator == current_user
      @reuniao.iniciar
      if @reuniao.save
        encaminhamentos_pendentes = buscar_encaminhamentos_acompanhamento(@reuniao)
        encaminhamentos_pendentes.each do |enc|
          if !@reuniao.encaminhamentos_pendentes.include?(enc)
            @reuniao.encaminhamentos_pendentes << enc
          end
        end
      else
        i = -1
        @reuniao.errors.full_messages.each do |msg|
          flash["error_#{i+=1}"] = msg
        end
      end
    else 
      
      flash.now["error"] = "Somente o coordenador ou redator pode iniciar a reunião"
    end
    redirect_to forum_reuniao_path(@forum, @reuniao)
  end

  def encerrar
    if @reuniao.coordenador == current_user || @reuniao.redator == current_user
      tem_erro = false
      i = -1
      @reuniao.assuntos.each do |assunto|
        if (assunto.encaminhamentos.any? || assunto.assuntos_filhos.any?) && assunto.notas.empty?
          flash["error_#{i+=1}"] = "Deve ser informado algum comentário no assunto #{assunto.descricao}"
          tem_erro = true
        end
      end

      @reuniao.encaminhamentos_pendentes.each do |enc|
        if enc.concluido?
          if enc.homologado && enc.encs_filhos.any?
            flash["error_#{i+=1}"] = "O encaminhamento #{enc.descricao} não pode ser homologado. Para aceitar a conclusão deste encaminhamento, você deve excluir todos os encaminhamentos redefinidos."
            tem_erro = true
          end

          if !enc.homologado && enc.encs_filhos.empty?
            flash["error_#{i+=1}"] = "Para não aceitar a conclusão do encaminhamento #{enc.descricao} , você deve adicionar novos encaminhamentos a ele."
            tem_erro = true
          end
        end  
      end

      @reuniao.encaminhamentos.each do |encaminhamento|
        if !encaminhamento.emailed?
          encaminhamento.notificar_usuarios
        end
      end  
      
      if !tem_erro
        @reuniao.encerrar(current_user)
        @reuniao.save
      end
    else
      flash["error"] = "Somente o coordenador ou redator pode encerrar a reunião"
    end
    redirect_to forum_reuniao_path(@forum, @reuniao)
  end

  def confirmar
    if @reuniao.status.confirmada?
      flash.now["error"] = "A reunião já está confirmada!"
      redirect_to forum_reuniao_path(@forum, @reuniao)
    else
      respond_with(@reuniao)
    end  
  end

  def confirmar_save
    if params[:reuniao][:assunto_ids].nil? || params[:reuniao][:assunto_ids].empty?
      flash.now["error"] = "Selecione pelo menos um assunto!"
      render "confirmar"
    else

      @reuniao.assign_attributes(params_reuniao)
      @reuniao.status = :confirmada
      if @reuniao.coordenador.present? && @reuniao.coordenador.is_a?(String)
        @reuniao.coordenador = User.find(@reuniao.coordenador)
      end

      if @reuniao.redator.present? && @reuniao.redator.is_a?(String)
        @reuniao.redator = User.find(@reuniao.redator)
      end

      if @reuniao.controlador.present? && @reuniao.controlador.is_a?(String)
        @reuniao.controlador = User.find(@reuniao.controlador)
      end

      idsparticipantes = params[:reuniao][:participantes].map(&:to_i)
      if @reuniao.participantes.any?
        @reuniao.participantes.clear
        User.where('id in (?)',idsparticipantes).each do |user|
          @reuniao.participantes << user
        end
      end

      idsconvidados = params[:reuniao][:convidados].map(&:to_i)
      if @reuniao.convidados.any?
        @reuniao.convidados.clear
        User.where('id in (?)',idsconvidados).each do |user|
          @reuniao.convidados << user
        end
      end

      if @reuniao.save
        @reuniao.criar_convites("Convite durante a confirmacao de reunião.", current_user)
        @reuniao.criar_situacao(@reuniao, @reuniao.status_text, "Confirmação de reunião", current_user)
        @reuniao.enviar_notificacao(:confirmar_reuniao)
        redirect_to forum_reuniao_path(@forum, @reuniao), notice: "Reunião confirmada com sucesso"
      else
        render "confirmar"
      end
    end    
  end

  def ata
    respond_with [@forum, @reuniao] do |format|
      format.html
      format.pdf { render pdf: "ata-reuniao-#{@reuniao.id}.pdf", layout: 'pdf.html' }
    end
  end

  def compartilhar_ata
    emails = params[:emails].to_s.split(',')

    if emails.size > 0
      @emails = emails.map{|email| {email: email} }
      usuarios = User.where("ativo is true")
      emails_do_banco = []
      usuarios.each do |usuario|
        emails_do_banco.push(usuario.email)
      end  

      @reuniao.compartilhamentos.create(@emails)
      emails.each do |email|
        # if(emails_do_banco.include? email)
        #   NotificacaoMailer.delay.compartilhar_ata(@reuniao, email)
        # else
          NotificacaoMailer.delay.compartilhar_ata_nao_usuario(@reuniao, email, current_user)
        # end    
      end
    end
    respond_with [@forum, @reuniao]
  end

  private

    def set_reuniao
      @reuniao = resource_base.reunioes.find(params[:id])
    end

    def buscar_encaminhamentos_acompanhamento reuniao

        #concluidos nao homologados
        #ou encaminhamentos vencidos, fora do prazo
        #ou encaminhamentos nao iniciados ou pausados que falta 30% pra terminar o prazo
        # ou vão vencer antes da próxima reunião
 #       
#        or previsao < :data_proxima_reuniao
        proxima_reuniao = reuniao.evento.data_proxima_reuniao(nil)

        Encaminhamento.where("status <> 'CNL' and forum_id = :f 
          and ((status = 'CON' and data_homologacao is null)
             or (status <> 'CON' and (:hoje >= (created_at + age(previsao, created_at)*0.7) 
             or previsao < :data_proxima_reuniao)))", 
          {:f => reuniao.forum.id, :hoje => Time.now.to_date.beginning_of_day, 
            :data_proxima_reuniao => proxima_reuniao.nil? ? Time.now.to_date.beginning_of_day : proxima_reuniao})
          .order("previsao asc")
    end

    def params_reuniao
       params.require(:reuniao).permit(:titulo, :data, :data_hora, :data_antiga, :coordenador, :controlador,
        :redator, :local, :prazo_notificar, :motivo, {:assunto_ids => []}, {:participantes => []}, {:convidados => []})
    end

end

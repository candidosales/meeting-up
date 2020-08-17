class AssuntosController < ForumBaseController
  respond_to :html, :js

  before_filter :authenticate_user!
  has_scope :por_descricao
  has_scope :with_status
  has_scope :with_prioridade
  has_scope :por_forum_origem
  has_scope :por_forum_destino

  before_action :set_assunto, only: [:show, :edit, :update, :destroy, :download_file]

  def index
    assuntos_pesquisados = nil
    if params[:origem_assunto] == 'interno'
      assuntos_pesquisados = Assunto.interno(resource_base)
    elsif params[:origem_assunto] == 'externo'
      assuntos_pesquisados = Assunto.externo(resource_base)
    elsif params[:origem_assunto] == 'encaminhado'
      assuntos_pesquisados = Assunto.encaminhados(resource_base)
    else
      assuntos_pesquisados = Forum.assuntos_internos_externos(resource_base)
    end
    @assuntos = apply_scopes(assuntos_pesquisados).order(id: :desc).page params[:page]
    respond_with(@assuntos)
  end

  def show
    respond_with(@forum,@assunto)
  end

  def new
    @assunto = resource_base.assuntos.build
    @assunto.forum_destino = @forum
    @assunto.forum = @forum
    respond_with(@forum, @assunto)
  end

  def edit
    respond_with(@assunto)
  end

  def create
    parameters = params_assunto
    if parameters[:discutido].nil?
      parameters[:discutido] = false
    end
    
    if current_user != resource_base.coordenador && (parameters[:forum_destino_id].nil? || parameters[:forum_destino_id].empty?)
      parameters[:forum_destino_id] = @forum.id
      parameters[:forum_id] = @forum.id
    end

    @assunto = resource_base.assuntos.create(parameters)
    
    if @assunto.valid?
      if @assunto.usuario.nil?
        @assunto.update(:usuario => current_user)
      end

      @assunto.criar_situacao_inicial(current_user)
    end
    
    respond_with(@forum, @assunto)
  end

  def update

    @assunto.update_attributes(params_assunto)
    respond_with(@forum, @assunto)
  end

  def destroy
    @assunto.destroy
    respond_with(@forum, @assunto)
  end

  def download_file
        send_file(@assunto.file.path,
              :disposition => 'attachment',
              :url_based_filename => false)
  end

  private
    def set_assunto
      @assunto = Forum.assuntos_internos_externos(resource_base).find(params[:id])
    end

    def params_assunto
      params.require(:assunto).permit(:descricao, :detalhamento, :prioridade, :file, :categoria_id, 
        :forum_destino_id, :pai_id, :usuario_id, :discutido, notas_attributes: [:id, :descricao, :usuario_id, :notable_id, :_destroy],
        encaminhamentos_attributes: [:id, :descricao, { :user_ids =>[] }, :assunto_id, :reuniao_id, 
        :forum_id, :_destroy])
    end

end

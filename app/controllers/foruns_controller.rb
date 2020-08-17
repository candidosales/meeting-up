class ForunsController < ApplicationController

  layout :set_layout, only: :index
  before_filter :authenticate_any!
  before_action :set_forum, only: [:show, :edit, :update, :destroy]

  has_scope :por_nome
  has_scope :por_coordenador
  has_scope :por_forum_pai


  def index
    @foruns = Forum.acessiveis(!current_user.nil? ? current_user : current_admin)
    if !current_admin.nil?
      @foruns = apply_scopes(@foruns).order(id: :asc).page params[:page]
    else
      @foruns = @foruns.order(id: :asc)
    end

    if @foruns.size == 1 && !current_user.nil?
      redirect_to forum_path(@foruns[0])
    else
       respond_with(@foruns)
    end  
  end

  def show
    respond_with(@forum)
  end

  def new
    @forum = Forum.new
    respond_with(@forum)
  end

  def edit
    respond_with(@forum)
  end

  def create
    @forum = Forum.new(forum_params)

    if @forum.save
      @forum.participantes.each do |participante|
        NotificacaoMailer.delay.novo_forum(@forum, participante)
      end
    end
    respond_with(@forum, :location => @forum)
  end

  def update
    ids_participantes_param = params[:forum][:participante_ids]
    ids_participantes_param.delete("")
    ids_participantes_forum = []

    @forum.participantes.each do |participante|
      ids_participantes_forum << participante.id.to_s
    end

    @forum.update_attributes(forum_params)
    unless @forum.pai.nil? 
      @forum.pai.atualizar_filhos(@forum) 
    end

    ids_adicionados = ids_participantes_param - ids_participantes_forum
    ids_removidos = ids_participantes_forum - ids_participantes_param

    ultimas_reunioes = @forum.reunioes.with_status(:agendada, :confirmada)
    ids_adicionados.each do |id_user|
      participante = User.find(id_user.to_i)

      ultimas_reunioes.each do |ultima_reuniao|
        ultima_reuniao.evento.participantes << participante
        ultima_reuniao.evento.save
        convites_existentes = ultima_reuniao.convites.without_status(:cancelado).where('destinatario_id = ?', participante)
        if convites_existentes.empty?
          convite = Convite.create(mensagem: 'Convite durante a alteração do fórum.', user: current_user, funcao: :participante,
            reuniao: ultima_reuniao, destinatario: participante)
          ultima_reuniao.convites << convite
        end

      end
    end

    ids_removidos.each do |id_user|
      participante = User.find(id_user.to_i)
      ultimas_reunioes.each do |ultima_reuniao|
        ultima_reuniao.evento.participantes.delete(participante)
        ultima_reuniao.evento.save
        convites_a_deletar = ultima_reuniao.convites.without_status(:cancelado,:confirmado).where('destinatario_id = ?', participante)
        if convites_a_deletar.any?
          convites_a_deletar.each do |convite|
            convite.cancelar("Remoção de fórum")
            convite.save
          end
        end
      end
    end

    respond_with(@forum, :location => @forum)
  end

  private
  
    def set_forum
      @forum = Forum.find(params[:id])
    end

    def forum_params
      params.require(:forum).permit(:sigla, :nome, :descricao, :coordenador_id, :pai_id, {:participante_ids => []})

    end  

    def set_layout
      !current_admin.nil? ? 'application' : 'fullwidth'
    end
  
end

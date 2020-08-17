# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140922141745) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string   "nome"
    t.string   "email",              default: "", null: false
    t.string   "encrypted_password", default: "", null: false
    t.integer  "sign_in_count",      default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "failed_attempts",    default: 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree

  create_table "assuntos", force: :cascade do |t|
    t.string   "descricao"
    t.text     "detalhamento"
    t.text     "resumo"
    t.text     "decisao"
    t.boolean  "discutido"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "categoria_id"
    t.string   "arquivo_file_name"
    t.string   "arquivo_content_type"
    t.integer  "arquivo_file_size"
    t.datetime "arquivo_updated_at"
    t.integer  "forum_id"
    t.integer  "usuario_id"
    t.integer  "prioridade",           limit: 2
    t.integer  "forum_destino_id"
    t.integer  "status"
    t.integer  "situacoes_id"
    t.datetime "data_conclusao"
    t.integer  "pai_id"
    t.string   "file"
  end

  add_index "assuntos", ["categoria_id"], name: "index_assuntos_on_categoria_id", using: :btree
  add_index "assuntos", ["forum_destino_id"], name: "index_assuntos_on_forum_destino_id", using: :btree
  add_index "assuntos", ["forum_id"], name: "index_assuntos_on_forum_id", using: :btree
  add_index "assuntos", ["pai_id"], name: "index_assuntos_on_pai_id", using: :btree
  add_index "assuntos", ["situacoes_id"], name: "index_assuntos_on_situacoes_id", using: :btree
  add_index "assuntos", ["usuario_id"], name: "index_assuntos_on_usuario_id", using: :btree

  create_table "assuntos_eventos", id: false, force: :cascade do |t|
    t.integer "assunto_id", null: false
    t.integer "evento_id",  null: false
  end

  create_table "assuntos_reunioes", id: false, force: :cascade do |t|
    t.integer "assunto_id", null: false
    t.integer "reuniao_id", null: false
  end

  create_table "bairros", force: :cascade do |t|
    t.string   "nome"
    t.integer  "cidade_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cargos", force: :cascade do |t|
    t.string   "descricao"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categorias", force: :cascade do |t|
    t.string   "descricao"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "categoria_pai_id"
  end

  add_index "categorias", ["categoria_pai_id"], name: "index_categorias_on_categoria_pai_id", using: :btree

  create_table "cidades", force: :cascade do |t|
    t.string   "nome"
    t.integer  "estado_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "compartilhamentos", force: :cascade do |t|
    t.integer  "reuniao_id"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "compartilhamentos", ["reuniao_id"], name: "index_compartilhamentos_on_reuniao_id", using: :btree

  create_table "convites", force: :cascade do |t|
    t.datetime "data_confirmacao"
    t.datetime "data_recusa"
    t.text     "mensagem"
    t.integer  "reuniao_id"
    t.integer  "user_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "funcao"
    t.integer  "destinatario_id"
    t.text     "motivo_recusa"
  end

  add_index "convites", ["destinatario_id"], name: "index_convites_on_destinatario_id", using: :btree
  add_index "convites", ["reuniao_id"], name: "index_convites_on_reuniao_id", using: :btree
  add_index "convites", ["user_id"], name: "index_convites_on_user_id", using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "documentos", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.binary   "arquivo"
    t.integer  "documentable_id"
    t.string   "documentable_type"
    t.string   "file"
  end

  create_table "empresas", force: :cascade do |t|
    t.string   "nome"
    t.string   "cnpj"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
  end

  create_table "encaminhamentos", force: :cascade do |t|
    t.string   "status"
    t.string   "descricao"
    t.integer  "assunto_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "forum_id"
    t.integer  "reuniao_id"
    t.string   "codigo"
    t.date     "previsao"
    t.datetime "data_conclusao"
    t.integer  "pai_id"
    t.datetime "data_inicio"
    t.boolean  "homologado",          default: false
    t.datetime "data_homologacao"
    t.date     "previsao_antiga"
    t.date     "previsao_solicitada"
    t.boolean  "emailed",             default: false
  end

  add_index "encaminhamentos", ["forum_id"], name: "index_encaminhamentos_on_forum_id", using: :btree
  add_index "encaminhamentos", ["pai_id"], name: "index_encaminhamentos_on_pai_id", using: :btree

  create_table "encaminhamentos_users", id: false, force: :cascade do |t|
    t.integer "user_id",           null: false
    t.integer "encaminhamento_id", null: false
  end

  create_table "enderecos", force: :cascade do |t|
    t.integer  "tipo_id"
    t.string   "logradouro"
    t.integer  "numero"
    t.string   "cep"
    t.string   "ponto_referencia"
    t.string   "complemento"
    t.string   "latitude"
    t.string   "longitude"
    t.integer  "cidade_id"
    t.integer  "bairro_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "estados", force: :cascade do |t|
    t.string   "nome"
    t.string   "uf",         limit: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "eventos", force: :cascade do |t|
    t.string   "titulo"
    t.datetime "data_inicial"
    t.datetime "data_final"
    t.integer  "forum_id"
    t.integer  "coordenador_id"
    t.integer  "redator_id"
    t.integer  "controlador_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "local_id"
    t.integer  "periodicidade_id"
    t.string   "status"
    t.integer  "user_id"
  end

  add_index "eventos", ["controlador_id"], name: "index_eventos_on_controlador_id", using: :btree
  add_index "eventos", ["coordenador_id"], name: "index_eventos_on_coordenador_id", using: :btree
  add_index "eventos", ["forum_id"], name: "index_eventos_on_forum_id", using: :btree
  add_index "eventos", ["local_id"], name: "index_eventos_on_local_id", using: :btree
  add_index "eventos", ["periodicidade_id"], name: "index_eventos_on_periodicidade_id", using: :btree
  add_index "eventos", ["redator_id"], name: "index_eventos_on_redator_id", using: :btree
  add_index "eventos", ["user_id"], name: "index_eventos_on_user_id", using: :btree

  create_table "eventos_users", id: false, force: :cascade do |t|
    t.integer "user_id",   null: false
    t.integer "evento_id", null: false
  end

  create_table "foruns", force: :cascade do |t|
    t.string   "nome"
    t.integer  "coordenador_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "sigla"
    t.text     "descricao"
    t.integer  "pai_id"
  end

  add_index "foruns", ["coordenador_id"], name: "index_foruns_on_coordenador_id", using: :btree
  add_index "foruns", ["pai_id"], name: "index_foruns_on_pai_id", using: :btree

  create_table "foruns_users", id: false, force: :cascade do |t|
    t.integer "user_id",  null: false
    t.integer "forum_id", null: false
  end

  create_table "lembretes", force: :cascade do |t|
    t.string   "tipo"
    t.integer  "intervalo",      default: 1
    t.string   "periodo"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lembrable_id"
    t.string   "lembrable_type"
    t.boolean  "enviado",        default: false
  end

  create_table "locais", force: :cascade do |t|
    t.string   "descricao"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "nota", force: :cascade do |t|
    t.text     "descricao"
    t.integer  "usuario_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "notable_id"
    t.string   "notable_type"
  end

  add_index "nota", ["notable_type", "notable_id"], name: "index_nota_on_notable_type_and_notable_id", using: :btree
  add_index "nota", ["usuario_id"], name: "index_nota_on_usuario_id", using: :btree

  create_table "notificacoes", force: :cascade do |t|
    t.string   "descricao"
    t.boolean  "status"
    t.string   "tipo"
    t.integer  "sender_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "periodicidades", force: :cascade do |t|
    t.string   "repeticao"
    t.integer  "repete_cada"
    t.text     "frequencia"
    t.date     "inicio"
    t.integer  "evento_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "frequencia_mensal"
  end

  add_index "periodicidades", ["evento_id"], name: "index_periodicidades_on_evento_id", using: :btree

  create_table "reunioes", force: :cascade do |t|
    t.datetime "data"
    t.string   "status"
    t.datetime "datacancelamento"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "local_id"
    t.integer  "evento_id"
    t.date     "prazo_notificar"
    t.string   "titulo"
    t.integer  "forum_id"
    t.datetime "inicio"
    t.datetime "fim"
    t.integer  "user_id"
    t.datetime "data_antiga"
    t.string   "codigo"
    t.string   "tipo"
  end

  add_index "reunioes", ["evento_id"], name: "index_reunioes_on_evento_id", using: :btree
  add_index "reunioes", ["forum_id"], name: "index_reunioes_on_forum_id", using: :btree
  add_index "reunioes", ["local_id"], name: "index_reunioes_on_local_id", using: :btree
  add_index "reunioes", ["user_id"], name: "index_reunioes_on_user_id", using: :btree

  create_table "reunioes_encaminhamentos_pendentes", id: false, force: :cascade do |t|
    t.integer "reuniao_id",        null: false
    t.integer "encaminhamento_id", null: false
  end

  create_table "setores", force: :cascade do |t|
    t.string   "descricao"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "situacoes", force: :cascade do |t|
    t.string   "descricao"
    t.text     "motivo"
    t.integer  "user_id"
    t.datetime "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "situable_id"
    t.string   "situable_type"
  end

  add_index "situacoes", ["user_id"], name: "index_situacoes_on_user_id", using: :btree

  create_table "tipo_enderecos", force: :cascade do |t|
    t.string   "nome",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cargo_id"
    t.string   "nome"
    t.string   "matricula"
    t.string   "cpf"
    t.integer  "empresa_id"
    t.date     "data_nascimento"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "tipo"
    t.text     "qualificacao"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "setor_id"
    t.boolean  "ativo",                  default: false
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["empresa_id"], name: "index_users_on_empresa_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["setor_id"], name: "index_users_on_setor_id", using: :btree

end

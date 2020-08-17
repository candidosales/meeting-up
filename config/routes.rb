Meetingup::Application.routes.draw do

  @devise_path_names = {
    sign_in: 'entrar', sign_out: 'sair', sign_up: 'cadastrar',
    password: 'senha', confirmation: 'verificacao',
    unlock: 'desbloquear', registration: 'registrar'
  }

  devise_for :admins, path_names: @devise_path_names
  devise_for :users, path_names: @devise_path_names, :controllers => { :confirmations => "confirmations" }

  as :user do
    patch '/user/verificacao' => 'confirmations#update', :via => :patch, :as => :update_user_confirmation
  end  

  scope(path_names: {new: 'novo', edit: 'alterar'}) do

    scope(tipo: 'C') do
      resources :users, path: 'convidados', as: :convidados
    end

    resources :foruns do
       resources :eventos do
          get 'edit'
          patch 'update'
          get 'cancelar', on: :collection
          member do
              get 'buscar_cancelar'
              patch 'confirmar_cancelamento'
          end
       end

       resources :reunioes do
          member do
              get 'ata'
              post 'compartilhar_ata'
              patch 'adiar'
              patch 'reativar'
              patch 'cancelar'
              get 'add_remove_assuntos'
	            get 'confirmar'
              patch 'confirmar_save'
              get 'iniciar'
              get  'encerrar'
          end
       end

       resources :encaminhamentos do
          member do
              patch 'solicitar_adiar'
              patch 'adiar'
              get 'iniciar'
              patch 'pausar'
              patch 'cancelar'
              get 'concluir'
              patch 'homologar'
          end
       end 

       resources :assuntos do
          member do
            get 'download_file'
          end
       end
    end

    resources :cargos,
        :setores,
        :locais,
        :categorias        

    resources :convites do
      member do
        patch 'confirmar'
        get 'new_recusar'
        patch 'recusar'
        patch 'presente' => 'convites#chamada', convite: {status: 'Confirmado', data_confirmacao: Time.now}
        patch 'ausente' => 'convites#chamada', convite: {status: 'Recusado', data_recusa: Time.now}

      end
    end

    resources :notas, only: [:create, :destroy]

    resources :users, path: 'usuarios', only: [:new, :create, :edit, :update, :show, :index] do
      member do
        patch 'reenviaremailconfirmacao' => 'users#reenviar_email_confirmacao'
        patch 'ativar' => 'users#mudar_status', user: {status: 1}
        patch 'inativar' => 'users#mudar_status', user: {status: 0}
      end
    end
  end

authenticated :user do
  root :to => 'foruns#index', :as => :authenticated_root
end

authenticated :admin do
  root :to => 'foruns#index', :as => :authenticated_admin_root
end

root :to => redirect('/users/entrar')

get 'admin', to: redirect('/admins/entrar')


end

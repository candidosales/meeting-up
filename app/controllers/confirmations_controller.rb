class ConfirmationsController < Devise::ConfirmationsController
  # Remove the first skip_before_filter (:require_no_authentication) if you
  # don't want to enable logged users to access  skip_before_filter :require_no_authentication
 skip_before_filter :require_no_authentication
 skip_before_filter :authenticate_user!

#PUT /resource/confirmation
	def update
		with_unconfirmed_confirmable do
			if @confirmable.has_no_password?
				@confirmable.attempt_set_password(params[:user])
				user_params = {:cargo_id => params[:user][:cargo_id], :cpf => params[:user][:cpf], 
					:data_nascimento => params[:user][:data_nascimento], :avatar => params[:user][:avatar],
					:ativo => true}
				@confirmable.update_attributes(user_params)
				if @confirmable.valid?
					do_confirm
				else
					do_show
					@confirmable.errors.clear #so that we want render :new
				end
			else
				self.class.add.error_on(self, :email, :password_allready_set)
			end
		end

		if !@confirmable.errors.empty?
			self.resource = @confirmable
			render 'devise/confirmations/show'
		end
	end

# get /resource/confirmation?confirmation_taken=abcdef
	def show
		with_unconfirmed_confirmable do
			if @confirmable.has_no_password?
				do_show
			else
				do_confirm
			end
		end
		if !@confirmable.errors.empty?
			self.resource = @confirmable
			render 'devise/confirmations/new'
		end
	end

protected
	def with_unconfirmed_confirmable
	    original_token = params[:confirmation_token]
	    confirmation_token = Devise.token_generator.digest(User, :confirmation_token, original_token)
		@confirmable = User.find_or_initialize_with_error_by(:confirmation_token, confirmation_token)
		if !@confirmable.new_record?
			@confirmable.only_if_unconfirmed{yield}
		end
	end

	def do_show
		@confirmation_token = params[:confirmation_token]
		@requires_password = true
		self.resource = @confirmable
		render 'devise/confirmations/show'
	end

	def do_confirm
		@confirmable.confirm!
		set_flash_message :notice, :confirmed
		sign_in_and_redirect(resource_name, @confirmable)
	end
end
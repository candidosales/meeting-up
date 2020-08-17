module ReunioesHelper
	
	def campo_coordenador(reuniao, forum)

		convite_coordenador = Reuniao.coordenador(reuniao)
		if(!convite_coordenador.nil? && convite_coordenador.confirmado?)
			coordenadores = [convite_coordenador.destinatario]
			return coordenadores
		else
			return forum.participantes
		end	
	end

	def campo_redator(reuniao, forum)
		convite_redator = Reuniao.redator(reuniao)
		if(convite_redator != nil && convite_redator.confirmado?)
			redatores = [convite_redator.destinatario]
			return redatores
		else
			return forum.participantes
		end
	end

	def campo_controlador(reuniao, forum)
		convite_controlador = Reuniao.controlador(reuniao)
		if(convite_controlador != nil && convite_controlador.confirmado?)
			controladores = [convite_controlador.destinatario]
			return controladores
		else
			return forum.participantes
		end
	end

	def campo_assuntos(reuniao, forum)
		ids_assuntos = []
		reuniao.assuntos.each do |assunto|
			ids_assuntos << assunto.id
		end	 
		if !ids_assuntos.empty?
			return Assunto.find(:all, :conditions => ["id not in (?) and discutido is false and forum_id = ?", ids_assuntos, forum])
		else
			Assunto.where("discutido is false and forum_id = ?", forum)
		end
	end

	def campo_participantes(reuniao, forum)
		ids = []
	end
end

module EventosHelper

	def buscar_participantes (forum)

		participantes = []
		forum.participantes.each do | p |
			participantes << p
		end
		participantes << forum.coordenador
		participantes.uniq
	end

	def buscar_usuarios
		User.where("tipo <> 'C' and ativo = true")
	end

	def buscar_assuntos (forum)
		Assunto.where("discutido is false and forum_id = ?", forum.id)
	end

    def buscar_convidados (forum)
	    User.joins('left join foruns_users fu on fu.user_id = users.id')
	      .where("((users.tipo = 'N' and users.ativo = true and fu.forum_id <> :forum) or users.tipo = 'C') and
	        users.id <> :coodenador_id", forum: forum.id, coodenador_id: forum.coordenador.id)
	      .order(:nome).distinct
	end

end

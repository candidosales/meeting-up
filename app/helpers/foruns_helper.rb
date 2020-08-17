module ForunsHelper
	def buscar_pai(forum)
		if forum.persisted?
			return Forum.where('id <> ?', forum.id)
		end
		Forum.all
	end

	def recupera_participantes(forum)
		if !forum.persisted?
			return User.without_tipo(:convidado).where("ativo = true")
		end
		return User.without_tipo(:convidado).where("id <> ? and ativo = true", forum.coordenador.id)
	end

	def buscar_coordenadores
		User.without_tipo(:convidado).where("ativo = true")
	end
end

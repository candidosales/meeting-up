module CategoriasHelper

	def buscar_cat_pai c
		if !c.id.nil? 
			return Categoria.where('id <> ?', c.id)
		end
		Categoria.all
	end
end

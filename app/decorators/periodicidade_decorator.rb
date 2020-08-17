# coding: utf-8
module PeriodicidadeDecorator
	def descricao
	    if semanal?
	  	  return "A cada #{repete_cada} semana(s) cada #{frequencia.to_a.to_sentence}"
	    end
	    if mensal?
	      if (dia_mes?)
	        return "Mensal no dia #{evento.data_inicial.day}"
	      end
	      if (dia_semana?)
	         name = l (evento.data_inicial.to_date.name_of_week_day)
	         week = evento.data_inicial.to_date.week_of_month
	         return "Mensal no(a) #{week}ª #{name}"
	      end
	    end
    end
end

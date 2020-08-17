# == Schema Information
#
# Table name: periodicidades
#
#  id                :integer          not null, primary key
#  repeticao         :string(255)
#  repete_cada       :integer
#  frequencia        :text
#  inicio            :date
#  evento_id         :integer
#  created_at        :datetime
#  updated_at        :datetime
#  frequencia_mensal :string(255)
#

class Periodicidade < ActiveRecord::Base
	extend Enumerize

  belongs_to :evento
  serialize :frequencia

  enumerize :frequencia, in: {domingo: 'DO', segunda: 'SE', terca: 'TE', quarta: 'QA', quinta: 'QI', sexta: 'ST', sabado: 'SA'}, 
  	predicates: true, multiple: true

  enumerize :frequencia_mensal, in: {dia_mes: 'dia do mês', dia_semana: 'dia da semana'}, predicates: true

  # enumerize :repeticao, in: {todos_dias: 'Todos os dias', semanal: 'Semanal', mensal: 'Mensal', anual: 'Anual'},
  #  predicates: true     

  enumerize :repeticao, in: {semanal: 'Semanal'},
   predicates: true, scope: true	  	


  #  def descricao
  #      if self.semanal?
  #    	  return "A cada #{repete_cada} semana(s) cada #{frequencia.to_a.to_sentence}"
  #      end
  #      if (self.mensal?)
  #        if (self.dia_mes?)
  #          return "Mensal no dia #{self.evento.data_inicial.day}"
  #        end
  #        if (self.dia_semana?)
  #           name = self.evento.data_inicial.to_date.name_of_week_day
  #           week = self.evento.data_inicial.to_date.week_of_month
  #           return "Mensal no(a) #{week}ª #{name}"
  #        end
  #      end
  # 
  #  end


  def descricao
    return "A cada #{repete_cada} semana(s) cada #{frequencia.to_a.to_sentence}"
  end

end

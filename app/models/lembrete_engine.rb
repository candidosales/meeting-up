class LembreteEngine

	def self.run
		puts "======================="
		puts "Executando LembreteEngine em #{Time.now}"
		puts "Buscando reuniões..."
		reunioes = buscar_reunioes
		puts "Reuniões encontradas: #{reunioes.size}"

		puts "Processando evento das reuniões..."
		reunioes.each do |reuniao|
			puts "	Reunião ID: #{reuniao.id}"
			processar_eventos(reuniao)
		end
		puts "Fim da execução em #{Time.now}"
		puts " "
		puts " "

	end
	#handle_asynchronously :run

	def self.buscar_reunioes
		Reuniao.where("status in ('A', 'CO')")
	end

	def self.processar_eventos(reuniao)
		reuniao.evento.lembretes.each do |lembrete|
			unless lembrete.enviado
				processar_lembrete(reuniao, lembrete)
			end	
		end	
	end	

	def self.processar_lembrete(reuniao, lembrete)
		hora_lembrete = processar_hora(reuniao.data, lembrete)
		agora = Time.now
		if (agora >= hora_lembrete)
			puts "		Lembrete ID: #{lembrete.id}, a cada #{lembrete.intervalo} #{lembrete.periodo.text}"
			reuniao.enviar_notificacao(:lembrete_reuniao)	
			lembrete.enviado = true
			lembrete.save
		end	
	end	

	def self.processar_hora(data_reuniao, lembrete)
		if lembrete.periodo.minutos?
			return data_reuniao - (lembrete.intervalo * 60)
		elsif lembrete.periodo.horas?
			return data_reuniao - (lembrete.intervalo * 60 * 60)
		elsif lembrete.periodo.dias?
			return data_reuniao - (lembrete.intervalo * 60 * 60 * 24)
		elsif lembrete.periodo.semanas?
			return data_reuniao - (lembrete.intervalo * 60 * 60 * 24 * 7)
		end		
	end	
end

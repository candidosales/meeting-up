## VIKSTAR

Admin.create(email: "rafael.costa@vikstar.com.br", nome: "Rafael Soares", password: "12345678", password_confirmation: "12345678")
Admin.create(email: "elio.salles@vikstar.com.br", nome: "Elio Salles", password: "12345678", password_confirmation: "12345678")
# Admin.create(email: "caio.cesar@vikstar.com.br", nome: "Caio César", password: "12345678", password_confirmation: "12345678")

# DEMO

# Admin.create(email: "demo@meetingup.com.br", nome: "Usuario root", password: "12345678", password_confirmation: "12345678")

User.create(nome: "Usuario 1", cpf: "34421201790", email: "user3@mail.com", password: "12345678", password_confirmation: "12345678", tipo: "N", confirmed_at: Time.now)
User.create(nome: "Usuario 2", cpf: "00321911385", email: "user2@mail.com", password: "12345678", password_confirmation: "12345678", tipo: "N", confirmed_at: Time.now)
User.create(nome: "Usuario 3", cpf: "18475054145", email: "idel.the@gmail.com", password: "12345678", password_confirmation: "12345678", tipo: "N", confirmed_at: Time.now)

Local.create(descricao: "Sala de Reuniões 1")
Local.create(descricao: "Sala de Reuniões 2")

Categoria.create(descricao: "Inovação")
Categoria.create(descricao: "Expansão do negócio")
Categoria.create(descricao: "Gestão de Pessoas")
Categoria.create(descricao: "Gestão de Projetos")

Cargo.create(descricao: "Diretor")
Cargo.create(descricao: "Gerente Filial")
Cargo.create(descricao: "Coordenador")
Cargo.create(descricao: "Auxiliar Administrativo")

encs  = Encaminhamento.all
encs.each do |enc|
	enc.emailed = true
	enc.save
end	

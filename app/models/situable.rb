module Situable

  def criar_situacao(object, descricao, motivo, user)
    
    s = Situacao.new(situable: object, descricao: descricao, 
        motivo: motivo, 
        data: Time.now,
        user: user)
    s.save!
  end
end
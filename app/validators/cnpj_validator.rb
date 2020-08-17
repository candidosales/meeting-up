class CnpjValidator < Modulo11Validator

  LENGTH = 14
  FACTORS = [[5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2],
             [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2]]

  def initialize(options)
    options[:length]  = LENGTH
    options[:factors] = FACTORS
    super
  end

  def self.valid?(cnpj)
    Modulo11Validator.valid?(cnpj, LENGTH, FACTORS)
  end

end

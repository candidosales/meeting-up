class CpfValidator < Modulo11Validator

  LENGTH = 11
  FACTORS = [[10,  9, 8, 7, 6, 5, 4, 3, 2],
             [11, 10, 9, 8, 7, 6, 5, 4, 3, 2]]

  def initialize(options)
    options[:length]  = LENGTH
    options[:factors] = FACTORS
    super
  end

  def self.valid?(cpf)
    Modulo11Validator.valid?(cpf, LENGTH, FACTORS)
  end

end

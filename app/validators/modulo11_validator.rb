class Modulo11Validator < ActiveModel::EachValidator

  def check_validity!
    unless options.keys.include?(:length) and options.keys.include?(:factors)
      raise ArgumentError, 'Options unspecified. Specify the :length and :factors options.'
    end

    length = options[:length]
    unless length.is_a?(Integer) && length >= 0
      raise ArgumentError, ":length must be a nonnegative Integer"
    end

    factors = options[:factors]
    raise ArgumentError, ":factors must be an array" unless factors.is_a?(Array)
    raise ArgumentError, ":factors must be a non-empty array" if factors.empty?
  end

  def validate_each(record, attribute, value)
    record.errors.add(attribute) unless Modulo11Validator.valid?(value, options[:length], options[:factors])
  end


  class << self

    def valid?(value, length, factors_list)
      full_number = value.to_s.gsub(/[^0-9]/, '')
      return false if full_number.size != length

      check_digits_count = factors_list.size
      base_number = full_number[0...-check_digits_count]
      check_digits = full_number[-check_digits_count, check_digits_count]
      return check_digits == calculate_check_digits(base_number, factors_list)
    end

    def calculate_check_digits(base_number, factors_list)
      digits = base_number.split(//)
      factors_list.map do |factors|
        sum = digits.zip(factors).map{ |digit, factor| digit.to_i * factor }.sum
        check_digit(sum).tap do |check_digit|
          digits << check_digit
        end
      end.join('')
    end

    def check_digit(sum)
      remainder = sum % 11
      remainder < 2 ? 0 : 11 - remainder
    end

  end

end

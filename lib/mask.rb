module SimpleForm
  module Components
    module Mask

      DEFAULT_MASKS = {
        cpf: '999.999.999-99',
        cnpj: '99.999.999/9999-99',
        telefone: '(99) 9999-9999',
        cep: '99999-999',
        date: '99/99/9999',
        datetime: '99/99/9999 99:99',
        hour: '99:99'
      }

      def mask(wrapper_options)
        input_html_options['data-mask'] ||= mask_text
        nil
      end

      def mask_text
        DEFAULT_MASKS.fetch(options[:mask], options[:mask])
      end
    end
  end
end

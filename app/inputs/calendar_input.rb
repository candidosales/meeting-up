# https://github.com/eternicode/bootstrap-datepicker
class CalendarInput < SimpleForm::Inputs::Base
  enable :placeholder

  def input
    template.content_tag(:div, class: 'input-group date', data: datepicker_options) do
      "#{@builder.text_field(attribute_name, input_html_options.merge(value: formatted_value, data: { mask: '99/99/9999' }))}
      <span class='input-group-addon'>#{template.icon(:calendar)}</span>".html_safe
    end
  end

  def formatted_value
    I18n.localize(@builder.object.send(attribute_name), format: '%d/%m/%Y') rescue @builder.object.send(attribute_name)
  end

  def input_html_classes
    super.push('form-control')
  end

  def datepicker_options
    {
      date_autoclose: true,
      date_today_btn: 'linked',
      date_language: 'pt-BR',
      date_format: 'dd/mm/yyyy'
    }
  end
end

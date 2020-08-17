jQuery ->
  $(document).on 'focus', 'textarea.autoresize', ->
    $(this).addClass('open')

  $(document).on 'blur', 'textarea.autoresize', ->
    $(this).removeClass('open') if $(this).val() == ''


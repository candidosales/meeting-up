#= require jquery
#= require jquery_ujs
#= require bootstrap
#= require bootstrap-datepicker
#= require bootstrap-datepicker.pt-BR
#= require jquery_nested_form
#= require select2
#= require select2_locale_pt-BR
#= require masked-input
#= require textarea

jQuery ->
  $('input[data-mask]').each ->
    $(this).mask($(this).data('mask'))

  $('.input-group.date').datepicker()

  $('.select2-users').select2()

  $(document).on 'keyup', '.form-cancelar-reuniao textarea, .form-cancelar-evento textarea, .form-reativar-reuniao textarea, .form-cancelar-encaminhamento textarea, .form-pausar-encaminhamento textarea, .form-concluir-encaminhamento textarea', ->
    if $(this).val().trim() == ''
      $(this).parents('form').find('input[type="submit"]').attr('disabled', 'disabled')
    else
      $(this).parents('form').find('input[type="submit"]').removeAttr('disabled')

  #Botões ON OFF
  $('.btn-toggle').click ->
    $(this).find('.btn').toggleClass('active')
    
    if ($(this).find('.btn-primary').size()>0) 
    	$(this).find('.btn').toggleClass('btn-primary')
    
    if ($(this).find('.btn-danger').size()>0) 
    	$(this).find('.btn').toggleClass('btn-danger')
    
    if ($(this).find('.btn-success').size()>0) 
    	$(this).find('.btn').toggleClass('btn-success')
    
    if ($(this).find('.btn-info').size()>0) 
    	$(this).find('.btn').toggleClass('btn-info')
    
    $(this).find('.btn').toggleClass('btn-default')

  $('.modal-assunto-add-nota-enc').on 'hidden.bs.modal', ->
    id_assunto = $(this).data('assunto-id')
    img = $('#blockquote-assunto-' + id_assunto).find('img')
    text_img = $(img).data('text')
    if (!$('#notas-Assunto_' + id_assunto).html().trim())
      $(img).attr('src', 'http://placehold.it/60/8e44ad/FFF&text=' + text_img)
    else
      $(img).attr('src', 'http://placehold.it/60/4CAE4C/FFF&text=' + text_img)

  $('.modal-encaminhamento-add-nota-enc').on 'hidden.bs.modal', ->
    id_encaminhamento = $(this).data('encaminhamento-id')
    div_homologar = $('#homologar-enc-' + id_encaminhamento)
    if ($(div_homologar).length > 0)
      img = $('#blockquote-enc-' + id_encaminhamento).find('img.desc-enc')
      text_img = $(img).data('text')
      resultado_homologacao = $('#status-homologado-enc-' + id_encaminhamento).val()
      if(resultado_homologacao == 'true')
        $(img).attr('src', 'http://placehold.it/60/4CAE4C/FFF&text=' + text_img)
      if(resultado_homologacao == 'false')
        $(img).attr('src', 'http://placehold.it/60/C0C0C0/FFF&text=' + text_img)
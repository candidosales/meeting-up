#= require jquery
#= require bootstrap
#= require bootstrap-datepicker
#= require bootstrap-datepicker.pt-BR
#= require masked-input

jQuery ->
  $('input[data-mask]').each ->
    $(this).mask($(this).data('mask'))

  $('.input-group.date').datepicker()

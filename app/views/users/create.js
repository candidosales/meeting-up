<% div_id = "create-#{params['tipo_usuario']}_" %>
<% if @user.errors.empty? %>
  $('.usuario_nome_').val('').blur()
  $('.usuario_email_').val('').blur()
  $('.usuario_qualificacao_').val('').blur()
  $('.usuario_matricula_').val('').blur()
  c = $('#reuniao_convidados')
  p = $('#forum_participante_ids')
  co = $('#forum_coordenador_id')
  s = $("<option></option>").attr("value", "<%= @user.id %>").text("<%= @user.nome %>")
  <% if (params['tipo_usuario'] == 'convidado') %>
    $(c).append(s).find('option[value=' + <%= @user.id %> + ']').attr("selected", true)
    $(c).change()
  <% end %>

  <% if (params['tipo_usuario'] == 'participante') %>
    $(p).append(s).find('option[value=' + <%= @user.id %> + ']').attr("selected", true)
    $(p).change()
  <% end %>

  <% if (params['tipo_usuario'] == 'coordenador') %>
    $(co).append(s).val("<%= @user.id %>").attr("selected", true)
  <% end %>

  $('#add-convidado-confirmar').modal('hide')
  $("#add-<%=params['tipo_usuario'] %>-forum").modal('hide')
  $('#<%= div_id %>-messages').hide()
<% else %>
  $('#<%= div_id %>-messages').show()
  $('#<%= div_id %>-messages ul').html('<%= j(@user.errors.full_messages.map{|e| content_tag(:li, e) }.join('').html_safe ) %>')
<% end %>
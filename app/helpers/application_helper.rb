module ApplicationHelper
  def li_link_to(text, url_options, subject, action=:read)
    if can?(action, subject)
      content_tag(:li, link_to(text, url_options),
                  class: current_page?(url_options) ? 'active' : '')
    end
  end

  def forum_context?
    (params.key?('forum_id')) || (params['controller'] == 'foruns' && params['action'] != 'index')
  end

  def current_forum_id
    @current_forum_id ||= params['forum_id'] || params['id']
  end
end

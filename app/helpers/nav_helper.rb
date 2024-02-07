# frozen_string_literal: true

module NavHelper
  def action_for_page(pagy)
    pagy.page == 1 ? 'update' : 'append'
  end

  def nav_link(name, path)
    link_to name, path, class: "navlink #{path == request.path ? 'active' : ''}", data: { 'turbo-frame': '_top' }
  end
end

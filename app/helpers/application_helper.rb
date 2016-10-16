module ApplicationHelper
  def app_name
    Rails.application.class.parent_name.downcase
  end

  def layout_header
    controller = params[:controller] || ""
    action = params[:action] || ""
    parameters = params[:parameters]

    c_ar = controller.split(/[\/_]/).collect{ |e| e.singularize }
    controller_name = c_ar.collect{ |e| e.capitalize }.join
    css_id = c_ar.join('-')
    ng_controller="ng-controller=" + "\"#{controller_name}Ctrl\""
    id="id=\"#{css_id}-top\""
    "#{ng_controller} #{id} action=\"#{action}\" ng-cloak".html_safe
  end



  # NG
  def ng_link_to(value, options = nil, html_options = nil)
    # http://api.rubyonrails.org/classes/ActionView/Helpers/UrlHelper.html#method-i-link_to
    html_options = convert_options_to_data_attributes(options, html_options)

    url = url_for(options)
    content_tag(:"md-button", value, {"href": url, class: "md-primary"})
  end
end

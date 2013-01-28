Deface::Override.new(:virtual_path => "spree/admin/shared/_order_tabs",
                     :name => "add_reset_digitals_to_admin_orders",
                     :insert_after => ".sidebar",
                     :text => %q{
<%= content_tag(:p, button_link_to(t(:reset_downloads), reset_digitals_admin_order_url(@order)), class: 'clear') if @order.digital? or true %>
                      },
                     :disabled => false)

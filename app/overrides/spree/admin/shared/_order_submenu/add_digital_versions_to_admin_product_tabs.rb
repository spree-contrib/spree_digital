Deface::Override.new(
  virtual_path: 'spree/admin/shared/_order_tabs',
  name: 'add_digital_versions_to_admin_product_tabs',
  insert_bottom: '[data-hook="admin_order_tabs"]',
  text: <<-HTML
          <% if can?(:update, @order) && @order.some_digital? %>
            <li>
              <%= link_to_with_icon 'icon-cloud', Spree.t(:reset_downloads, scope: 'digitals'), reset_digitals_admin_order_url(@order) %>
            </li>
          <% end %>
        HTML
)

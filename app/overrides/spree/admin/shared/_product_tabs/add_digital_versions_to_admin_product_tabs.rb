Deface::Override.new(
  virtual_path: 'spree/admin/shared/_product_tabs',
  name: 'add_digital_versions_to_admin_product_tabs',
  insert_bottom: '[data-hook="admin_order_tabs"]',
  text: '<% if can?(:update, @order) && @order.digital? %>
          <li>
            <%= link_to_with_icon 'icon-cloud', Spree.t(:reset_downloads, scope: 'digitals'), reset_digitals_admin_order_url(@order) %>
          </li>
        <% end %>'
)

<!-- insert_bottom "[data-hook='admin_product_tabs'], #admin_product_tabs[data-hook]" -->

<li<%= ' class=\"active\"' if current == 'Digital Versions' %>>
  <%= link_to_with_icon 'cloud', Spree.t(:digital_versions, scope: 'digitals'), admin_product_digitals_path(@product) %>
</li>

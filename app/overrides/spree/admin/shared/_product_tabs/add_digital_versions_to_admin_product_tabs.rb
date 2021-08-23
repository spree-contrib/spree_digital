Deface::Override.new(
  virtual_path: 'spree/admin/shared/_product_tabs',
  name: 'add_digital_versions_to_admin_product_tabs',
  insert_bottom: '[data-hook="admin_product_tabs"]',
  text: <<-HTML
          <li class="<%= 'active' if current == 'Digital Versions' %>">
            <%= link_to_with_icon 'cloud', Spree.t(:digital_versions, scope: 'digitals'), admin_product_digitals_path(@product), class: 'nav-link' %>
          </li>
  HTML
)

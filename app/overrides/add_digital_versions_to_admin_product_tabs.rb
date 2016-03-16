Deface::Override.new(:virtual_path => "spree/admin/shared/_product_tabs",
                     :name => "add_digital_versions_to_admin_product_tabs",
                     :insert_bottom => "[data-hook='admin_product_tabs'], #admin_product_tabs[data-hook]",
                     :text => "    <li<%== ' class=\"active\"' if current == \"Digital Versions\" %>>
      <%= link_to admin_product_digitals_path(@product), class: 'icon_link with_tip fa fa-cloud' do %>
        <span class=\"text\"><%= Spree.t(:digital_versions, scope: 'digitals') %></span>
      <% end %>
    </li>
",
                     :disabled => false)

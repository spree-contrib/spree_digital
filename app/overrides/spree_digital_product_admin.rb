  Deface::Override.new(:virtual_path => "spree/admin/shared/_product_tabs",
                     :name => "spree_digital_product_admin",
                     :insert_bottom => "[data-hook='admin_product_tabs'], #admin_product_tabs[data-hook]",
                     :text => "    <li<%== ' class=\"active\"' if current == \"Digital Versions\" %>>
      <%= link_to t(\"digital_versions\"), admin_product_digitals_path(@product) %>
    </li>
",
                     :disabled => false)

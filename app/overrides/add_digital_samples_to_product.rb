Deface::Override.new(:virtual_path => "spree/products/show",
                     :name => "add_digital_samples_to_product",
                     :insert_bottom => "[data-hook='product_properties']",
                     :text => %q{
 <%= content_tag(:p, :class => 'download_links') do %>
   
   <% if @product.has_variants? %>
     
       <% @product.variants.each do |variant| %>
         <% if variant.digital_sample? %>
            <strong><%= t(:sample_notice) %>:</strong>
            <%= render variant.digital_samples %>
         <% end %>
         
       <% end %>
      
   <% else %>
     <% if @product.master.digital_sample? %>
        <strong><%= t(:sample_notice) %>:</strong>  
        <%= render @product.master.digital_samples %>
     <% end %>
   <% end %>
   
 <% end %>
             
                      },
                     :disabled => false)
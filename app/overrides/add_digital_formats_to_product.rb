Deface::Override.new(:virtual_path => "spree/products/show",
                     :name => "add_digital_formats_to_product",
                     :insert_before => "[data-hook='cart_form']",
                     :text => %q{
 <%= content_tag(:p, :class => 'download_links') do %>
   
   
   <% if @product.has_variants? %>
     
       <% @product.variants.each do |variant| %>
         <% if variant.digital? %>
             <h6 class="product-section-title"><%= t(:format_notice) %>:</h6>
             <strong><%= render variant.digitals %></strong>
           <% end %>

       <% end %>
      
   <% else %>
     <% if @product.master.digital? %>
       <h6 class="product-section-title"><%= t(:format_notice) %>:</h6>
       <strong><%= render @product.master.digitals %></strong>
     <% end %>
   <% end %>
 <% end %>
             
                      },
                     :disabled => false)
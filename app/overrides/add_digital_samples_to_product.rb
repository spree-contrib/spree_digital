Deface::Override.new(:virtual_path => "spree/products/show",
                     :name => "add_digital_samples_to_product",
                     :insert_bottom => "[data-hook='product_properties']",
                     :text => %q{
 <%= content_tag(:p, :class => 'download_links') do %>
   
   <% if @product.has_variants? %>
     
       <% @product.variants.each do |variant| %>
         <% if variant.digital? %>
           This product is available in the following formats:
           <%= render variant.digitals %>
         <% end %>
         
         <% if variant.digital_sample? %>
            <br/><br/>This product has the following Free Downloads:
            <%= render variant.digital_samples %>
         <% end %>
         
       <% end %>
      
   <% else %>

     <% if @product.master.digital? %>
       This product is available in the following formats:<br/>
       <%= render @product.master.digitals %>
     <% end %>

     <% if @product.master.digital_sample? %>
       <br/>This product has the following Free Downloads: 
            <%= render @product.master.digital_samples %>
     <% end %>
   <% end %>
   
 <% end %>
             
                      },
                     :disabled => false)
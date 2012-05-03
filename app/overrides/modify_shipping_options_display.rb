Deface::Override.new(:virtual_path => "spree/checkout/_delivery",
                     :name => "modify_shipping_options_display",
                     :replace_contents => "#shipping_method #methods p.radios",
                     :original => %q{
 <% @order.rate_hash.each do |shipping_method| %>
   <label>
     <%= radio_button(:order, :shipping_method_id, shipping_method[:id]) %>
     <% if Spree::Config[:shipment_inc_vat] %>
       <%= shipping_method[:name] %> <%= format_price (1 + Spree::TaxRate.default) * shipping_method[:cost] %>
     <% else %>
     <%= shipping_method[:name] %> <%= number_to_currency shipping_method[:cost] %>
     <% end %>
   </label>
 <% end %>
 },
                     :text => %q{
<% if @order.digital? && @order.digital_shipping_method.present? %>
<label>
  <%= radio_button :order, :shipping_method_id, @order.digital_shipping_method[:id] %>
  <%== t 'digital_shipping', :email => @order.email %> (<%= number_to_currency @order.digital_shipping_method[:cost] %>)
</label>
<% else %>
<% filtered_rate_hash = @order.rate_hash.select { |m| !(@order.digital_shipping_method && shipping_method[:id] == @order.digital_shipping_method[:id]) } %>
<% if filtered_rate_hash.count > 0 %>
<% filtered_rate_hash.each do |shipping_method| %>
<% next if @order.digital_shipping_method && shipping_method[:id] == @order.digital_shipping_method[:id] %>
  <label>
    <%= radio_button(:order, :shipping_method_id, shipping_method[:id]) %>
    <% if Spree::Config[:shipment_inc_vat] %>
      <%= shipping_method[:name] %> <%= format_price (1 + Spree::TaxRate.default) * shipping_method[:cost] %>
    <% else %>
    <%= shipping_method[:name] %> <%= number_to_currency shipping_method[:cost] %>
    <% end %>
  </label>
<% end %>
<% else %>
<%= t :no_shipping_methods %>
<% end %>
<% end %>
})
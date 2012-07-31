Deface::Override.new(:virtual_path => "spree/shared/_products",
                     :name => "add_digital_samples_to_product",
                     :insert_bottom => "td[data-hook='product_properties']",
                     :text => %q{
  <%= content_tag(:p, :class => 'download_links') do %>
    <% item.digital_samples.each do |digital_sample| %>
    <% format = File.extname(digital_sample.digital.attachment.path).downcase %>
      <%= link_to t(:digital_download, :type => t("digital_format#{format}")), digital_url(:host => Spree::Config.get(:site_url), :path => digital_sample.digital.attachment.path), :class => "btn #{format}" %>
    <% end %>
  <% end %>

                      },
                     :disabled => false)
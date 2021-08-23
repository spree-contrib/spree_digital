Deface::Override.new(
  virtual_path: 'spree/shared/_order_details',
  name: 'add_digital_downloads_to_invoice',
  insert_bottom: '[data-hook="order_item_description"]',
  text: <<-HTML
          <% if @order.state == 'complete' && @order.paid? && item.variant.digital? %>
            <div data-hook='download_links'>
              <ul>
                <% item.digital_links.each do |digital_link| %>
                  <li>
                    <%= link_to Spree.t('digitals.digital_download', filename: raw(digital_link.digital.attachment_file_name)), digital_url(secret: digital_link.secret) %>
                  </li>
                <% end %>
              </ul>
            </div>
          <% end %>
  HTML
)

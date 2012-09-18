Spree::Order.class_eval do
  # all products are digital
  def digital?
    line_items.map { |item| return false unless item.digital? }
    true
  end
  
  def some_digital?
    line_items.map { |item| return true if item.digital? }
    false
  end

  def reset_digital_links!
    line_items.select(&:digital?).map(&:digital_links).flatten.each do |digital_link|
      digital_link.update_column :access_counter, 0
      digital_link.update_column :created_at, Time.now
    end
  end

  # UPGRADE_CHECK this works as of spree 1.2.0. check function for changes on upgrade
  def available_shipping_methods(display_on = nil)
    return [] unless ship_address
    all_methods = Spree::ShippingMethod.all_available(self, display_on)

    if self.digital?
      all_methods.detect { |m| m.calculator.class == Spree::Calculator::DigitalDelivery }.try { |d| [d] } || all_methods
    else
      all_methods
    end
  end
end

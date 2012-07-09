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

  # UPGRADE_CHECK
  # TODO this works as of spree 1.1.1; make sure to check the original function on upgrade

  def available_shipping_methods(display_on = nil)
    return [] unless ship_address
    all_methods = Spree::ShippingMethod.all_available(self, display_on)
    puts "ALL METHODS #{all_methods.count} #{display_on}"
    if self.digital?
      all_methods.detect { |m| m.calculator.class == Spree::Calculator::DigitalDelivery }.try { |d| [d] } || all_methods
    else
      all_methods
    end
  end
end

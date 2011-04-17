Order.class_eval do
  
  # Are all products/variants of this Order to be downloaded by the customer?
  def digital?
    line_items.map { |item| return false unless item.digital? }
    true
  end
  
  # Determine which method to use for shipping of digital products.
  def digital_shipping_method
    rates = rate_hash
    # If there is a shipping method has "Download" in its name then we take that one.
    rates.each { |rate| return rate if rate[:name].downcase.include?('download') }
    # Other than that, we take the first one that we find that doesn't cost anything.
    rates.each { |rate| return rate if rate[:cost] == 0 }
    # Well, at this point we have a problem. No shipping method is cost-free or called "download".
    nil
  end

end
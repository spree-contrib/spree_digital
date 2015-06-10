Spree::Order.class_eval do
  register_update_hook :generate_digital_links

  # all products are digital
  def digital?
    line_items.all? { |item| item.digital? }
  end
  
  def some_digital?
    line_items.any? { |item| item.digital? }
  end

  def digital_line_items
    line_items.select(&:digital?)
  end

  def digital_links
    digital_line_items.map(&:digital_links).flatten
  end

  def reset_digital_links!
    digital_links.each do |digital_link|
      digital_link.reset!
    end
  end

  def generate_digital_links
    self.line_items.each{|a|a.create_digital_links} 
  end

end

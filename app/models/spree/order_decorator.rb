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

end

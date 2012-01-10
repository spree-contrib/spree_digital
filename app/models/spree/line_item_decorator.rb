Spree::LineItem.class_eval do
  
  has_many :digital_links
  
  after_save :create_digital_links, :if => :digital?
  after_destroy :check_shipping_method
  
  # Is this item digital?
  def digital?
    variant.digital?
  end
  
  private
  
  # Create the download link for this item if it is digital.
  def create_digital_links
    digital_links.delete_all
    self.quantity.times do
      digital_links.create!(:digital => variant.digital)
    end
  end
  
  def check_shipping_method
    if order.digital?
      if order.shipment.present?
        order.shipment.update_attributes(:shipping_method_id => order.digital_shipping_method[:id])
      end
    end
  end
  
end

Spree::LineItem.class_eval do
  has_many :digital_links, :dependent => :destroy
  # after_save :create_digital_links, :if => :digital?
  
  def digital?
    variant.digital?
  end
  
  # TODO: PMG - Shouldn't we only do this if the quantity changed?
  def create_digital_links
    if self.digital? && self.order.complete?
      digital_links.delete_all

      #include master variant digitals
      master = variant.product.master
      if(master.digital?)
        create_digital_links_for_variant(master)
      end
      create_digital_links_for_variant(variant) unless variant.is_master
    end
  end

  def create_digital_links_for_variant(variant)
    variant.digitals.each do |digital|
      self.quantity.times do
        digital_links.create!(:digital => digital, :user_id => self.order.user_id)
      end      
    end
  end

  
end

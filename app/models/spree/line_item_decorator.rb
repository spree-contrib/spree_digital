Spree::LineItem.class_eval do
  
  has_many :digital_links, :dependent => :destroy
  after_save :create_digital_links, :if => :digital?
  
  def digital?
    variant.digital?
  end
  
  private
  
  # TODO there is no reason to create the digital links until the order is complete
  def create_digital_links
    digital_links.delete_all

    variant.digitals.each do |digital|
      self.quantity.times do
        digital_links.create!(:digital => digital)
      end      
    end
  end
  
end

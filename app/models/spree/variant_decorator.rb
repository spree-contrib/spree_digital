Spree::Variant.class_eval do
  has_many :digitals
  after_save :destroy_digital, :if => :deleted?
  
  # Is this variant to be downloaded by the customer?
  def digital?
    digitals.present?
  end
  
  private
  
  # :dependent => :destroy needs to be handled manually
  # spree does not delete variants, just marks them as deleted?
  # optionally keep digitals around for customers who require continued access to their purchases
  def destroy_digital
    digitals.map &:destroy unless Spree::DigitalConfiguration[:keep_digitals]
  end

end

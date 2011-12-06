Spree::Variant.class_eval do
  
  has_one :digital, :dependent => :destroy
  after_save :destroy_digital, :if => :deleted?
  
  # Is this variant to be downloaded by the customer?
  def digital?
    digital.present?
  end
  
  private
  
  # Spree never deleted Digitals, that's why ":dependent => :destroy" won't work on Digital.
  # We need to delete the Digital manually here as soon as the Variant is nullified.
  # Otherwise you'll have orphan Digitals (and their attached files!) associated with unused Variants. 
  def destroy_digital
    digital.destroy
  end

end

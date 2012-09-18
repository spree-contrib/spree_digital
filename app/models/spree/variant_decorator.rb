Spree::Variant.class_eval do
  has_many :digitals, :dependent => :destroy
  
  # Is this variant to be downloaded by the customer?
  def digital?
    digitals.present?
  end
end

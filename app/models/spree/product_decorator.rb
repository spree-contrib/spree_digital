
Spree::Product.class_eval do
  has_many :digitals, :through => :variants_including_master
end
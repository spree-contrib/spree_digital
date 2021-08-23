digital_shipping_category = Spree::ShippingCategory.find_or_create_by!(name: 'Digital')

Spree::ShippingMethod.find_or_initialize_by(name: 'Download') do |shipping_method|
  shipping_method.calculator = Spree::Calculator::Shipping::DigitalDelivery.create!
  shipping_method.zones = Spree::Zone.all
  shipping_method.display_on = 'both'
  shipping_method.shipping_categories = [digital_shipping_category]
  shipping_method.save!
end

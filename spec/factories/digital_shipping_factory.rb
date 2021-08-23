FactoryBot.define do
  # https://github.com/thoughtbot/factory_bot/blob/master/GETTING_STARTED.md#modifying-factories

  factory :digital_shipping_calculator, class: Spree::Calculator::Shipping::DigitalDelivery do
    after :create do |c|
      c.set_preference(:amount, 0)
    end
  end

  factory :digital_shipping_method, parent: :shipping_method do
    name       { 'Digital Delivery' }
    calculator { FactoryBot.build :digital_shipping_calculator }
  end
end

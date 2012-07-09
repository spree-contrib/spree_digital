FactoryGirl.define do
  # https://github.com/thoughtbot/factory_girl/blob/master/GETTING_STARTED.md#modifying-factories

  factory :digital_shipping_calculator, class: Spree::Calculator::DigitalDelivery do |c|
    after_create { |c| c.set_preference(:amount, 0) }
  end

  factory :digital_shipping_method, parent: :shipping_method do |f|
    name "Digital Delivery"
    calculator { FactoryGirl.build :digital_shipping_calculator }
  end
end
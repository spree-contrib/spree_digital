FactoryGirl.define do
  factory :digital, :class => Spree::Digital do |f|
    # TODO good to assign variant association if no association is manually defined
    # f.variant { |p| p.association(:variant) }
  end
end
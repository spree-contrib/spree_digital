FactoryGirl.define do
  factory :digital, :class => Spree::Digital do |f|
    f.variant { |p| p.association(:variant) }
  end
end
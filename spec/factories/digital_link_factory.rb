FactoryBot.define do
  factory :digital_link, class: Spree::DigitalLink do |f|
    f.digital   { |p| p.association(:digital) }
    f.line_item { |p| p.association(:line_item) }
    created_at  { 1.days.ago }
  end
end

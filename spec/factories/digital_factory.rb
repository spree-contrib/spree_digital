Factory.define :digital, :class => Spree::Digital do |f|
  f.variant { |p| p.association(:variant) }
end
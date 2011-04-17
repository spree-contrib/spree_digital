Factory.define :digital do |f|
  f.variant { |p| p.association(:variant) }
end
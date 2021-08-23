module Spree
  module ProductDecorator
    def self.prepended(base)
      base.has_many :digitals, through: :variants_including_master
    end
  end
end

::Spree::Product.prepend(Spree::ProductDecorator)

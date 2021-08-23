module Spree
  module VariantDecorator
    def self.prepended(base)
      base.has_many :digitals
      base.after_save :destroy_digital, if: :deleted?
    end

    # Is this variant to be downloaded by the customer?
    def digital?
      digitals.present?
    end

    private

    # :dependent => :destroy needs to be handled manually
    # spree does not delete variants, just marks them as deleted?
    # optionally keep digitals around for customers who require continued access to their purchases
    def destroy_digital
      return if Spree::DigitalConfiguration[:keep_digitals]

      digitals.map(&:destroy)
    end
  end
end

::Spree::Variant.prepend(Spree::VariantDecorator)

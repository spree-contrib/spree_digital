module Spree
  module LineItemDecorator
    def self.prepended(base)
      base.has_many :digital_links, dependent: :destroy
      base.after_save :create_digital_links, if: :digital?

      base.delegate :digital?, to: :variant
    end

    protected

    # TODO: there is no reason to create the digital links until the order is complete
    # TODO: PMG - Shouldn't we only do this if the quantity changed?
    def create_digital_links
      digital_links.delete_all

      # include master variant digitals
      master = variant.product.master
      create_digital_links_for_variant(master) if master.digital?

      create_digital_links_for_variant(variant) unless variant.is_master?
    end

    def create_digital_links_for_variant(variant)
      variant.digitals.each do |digital|
        quantity.times do
          digital_links.create!(digital: digital)
        end
      end
    end
  end
end

::Spree::LineItem.prepend(Spree::LineItemDecorator)

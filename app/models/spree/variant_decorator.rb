module Spree
  module VariantDecorator
    def self.prepended(base)
      base.has_many :digitals
      base.after_save :destroy_digitals, if: :deleted?

      base.scope :digital, -> { joins(:digitals) }
    end
  
    # has digital option_type
    def has_digital_option?
      # self.option_values.select{|a|a.option_type.name.eql?('digital')}.present?
      self.option_values.joins(option_type: :translations).where("spree_option_type_translations.name = 'digital'").present?
    end

    # has digital option_type as true
    def has_true_digital_option?
      # self.option_values.select{|a|a.option_type.name.eql?('digital') && a.name.eql?('true')}.present?
      self.option_values.joins(:translations, option_type: :translations).where("spree_option_type_translations.name = 'digital' AND spree_option_value_translations.name = 'true'").present?
    end

    # if it is a digital variant should have digital attachment
    def is_complete?
      self.has_true_digital_option? ? self.digital? : true    
    end

    # has digital option_type as true and has digital attachments
    def digital?
      (self.has_true_digital_option? && self.digitals.present?) ? true : false
    end

    def track_inventory
      self.digital? ? false : super
    end
    
    private
    # :dependent => :destroy needs to be handled manually
    # spree does not delete variants, just marks them as deleted?
    # optionally keep digitals around for customers who require continued access to their purchases
    def destroy_digital
      digitals.map &:destroy unless Spree::DigitalConfiguration[:keep_digitals]
    end
  end
end

::Spree::Variant.prepend Spree::VariantDecorator if ::Spree::Variant.included_modules.exclude?(Spree::VariantDecorator)

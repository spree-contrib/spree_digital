# https://github.com/spree/spree/issues/1439
require_dependency 'spree/calculator'

module Spree
  class Calculator::DigitalDelivery < Calculator::FlatRate
    def self.description
      I18n.t(:digital_delivery)
    end

    def compute(object=nil)
      self.preferred_amount
    end

    def available?(package)
      package.contents.all? { |content| content.variant.digital? }
    end
  end
end

module Spree
  module UserDecorator
    def self.prepended(base)
      base.has_many :digital_links, -> { order(:updated_at) }, foreign_key: :user_id, class_name: 'Spree::DigitalLink'
    end

    def digital_signature
      I18n.t("spree.digitals.copy_for", name: self.full_name, email: self.email)
    end

    def full_name
      self.billing_address.present? ? self.billing_address.full_name : (self.name || self.email)
    end
  end
end

::Spree::User.prepend Spree::UserDecorator if ::Spree::User.included_modules.exclude?(Spree::UserDecorator)

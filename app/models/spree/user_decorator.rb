Spree.user_class.class_eval do
  has_many :digital_links, -> {order(:updated_at)}, foreign_key: :user_id, class_name: 'Spree::DigitalLink'

  def digital_signature
    I18n.t("spree.digitals.copy_for", name: self.full_name, email: self.email)
  end

  def full_name
    self.billing_address.present? ? self.billing_address.full_name : (self.name || self.email)
  end
end
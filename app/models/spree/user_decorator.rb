Spree.user_class.class_eval do
  has_many :digital_links, -> {order(:updated_at)}, foreign_key: :user_id, class_name: 'Spree::DigitalLink'
end
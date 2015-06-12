Spree::Product.class_eval do
  has_many :digitals, :through => :variants_including_master
  scope :digital, -> { joins(:digitals).order(:updated_at).uniq}
end
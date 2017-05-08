Spree::Product.class_eval do
  has_many :digitals, :through => :variants_including_master
  scope :digital, -> { joins(:digitals).order(:updated_at).uniq}

  def has_digital_variants?
    self.digital_variants.present?
  end

  def digital_variants
    self.variants_including_master.select{|a| a.has_true_digital_option?}
  end
end
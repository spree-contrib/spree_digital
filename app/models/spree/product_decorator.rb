Spree::Product.class_eval do
  has_many :digitals, :through => :variants_including_master
  scope :digital, -> { includes(:digitals).reorder("spree_digitals.updated_at DESC").distinct }

  def has_paper_or_digital_variants?
    self.variants_including_master.any?{|a| a.has_digital_option?}
  end

  def has_digital_variants?
    self.digital_variants.present?
  end

  def digital_variants
    self.variants_including_master.select{|a| a.has_true_digital_option?}
  end
end

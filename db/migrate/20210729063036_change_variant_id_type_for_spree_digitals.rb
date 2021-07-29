class ChangeVariantIdTypeForSpreeDigitals < ActiveRecord::Migration[4.2]
  def change
    change_column :spree_digitals, :variant_id, :bigint
  end
end

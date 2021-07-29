class ChangeDigitalIdAndLineItemIdTypesForSpreeDigitalLinks < ActiveRecord::Migration[4.2]
  def change
    change_table(:spree_digital_links) do |t|
      t.change :digital_id, :bigint
      t.change :line_item_id, :bigint
    end
  end
end

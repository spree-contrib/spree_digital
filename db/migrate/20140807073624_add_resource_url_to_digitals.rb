class AddResourceUrlToDigitals < ActiveRecord::Migration
  def change
    add_column :spree_digitals, :resource_url, :string
    add_index :spree_digitals, :resource_url
  end
end

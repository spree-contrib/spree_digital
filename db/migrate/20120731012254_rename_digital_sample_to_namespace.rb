class RenameDigitalSampleToNamespace < ActiveRecord::Migration
  def change
    rename_table :digital_samples, :spree_digital_samples
  end
end

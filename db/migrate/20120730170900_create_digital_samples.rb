class CreateDigitalSamples < ActiveRecord::Migration
  
  def self.up
    create_table :digital_samples do |t|
      t.integer :variant_id
      t.string :attachment_file_name
      t.string :attachment_content_type
      t.integer :attachment_file_size
      t.timestamps
    end
    add_index :digital_samples, :variant_id

  end

  def self.down
    drop_table :digital_samples
  end
  
end
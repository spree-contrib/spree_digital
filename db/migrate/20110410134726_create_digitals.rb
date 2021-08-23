class CreateDigitals < SpreeExtension::Migration[4.2]
  def self.up
    create_table :digitals do |t|
      t.integer :variant_id
      t.string :attachment_file_name
      t.string :attachment_content_type
      t.integer :attachment_file_size
      t.timestamps
    end
    add_index :digitals, :variant_id

    create_table :digital_links, force: true do |t|
      t.integer :digital_id
      t.integer :line_item_id
      t.string  :secret
      t.integer :access_counter
      t.timestamps
    end
    add_index :digital_links, :digital_id
    add_index :digital_links, :line_item_id
    add_index :digital_links, :secret
  end

  def self.down
    drop_table :digitals
    drop_table :digital_links
  end
end

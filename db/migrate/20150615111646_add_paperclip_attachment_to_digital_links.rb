class AddPaperclipAttachmentToDigitalLinks < ActiveRecord::Migration
  def change
    add_column :spree_digital_links, :attachment_file_name, :string
    add_column :spree_digital_links, :attachment_content_type, :string
    add_column :spree_digital_links, :attachment_file_size, :integer
  end
end

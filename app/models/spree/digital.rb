module Spree
  class Digital < ActiveRecord::Base
    belongs_to :variant
    has_many :digital_links, dependent: :destroy
    after_save :delete_digital_links_attachments, if: :attachment_changed?

    has_attached_file :attachment, path: ":rails_root/private/digitals/:id/:basename.:extension"
    do_not_validate_attachment_file_type :attachment
    validates_attachment_presence :attachment

    if Paperclip::Attachment.default_options[:storage] == :s3
      attachment_definitions[:attachment][:s3_permissions] = :private
      attachment_definitions[:attachment][:s3_headers] = { :content_disposition => 'attachment' }
    end

    def attachment_changed?
      self.attachment_file_name_changed? || self.attachment_content_type_changed? || self.attachment_file_size_changed?
    end 

    private
    def delete_digital_links_attachments
      self.digital_links.each do |dl| 
        dl.remove_attachment_file = 1 and dl.save
      end
    end
  end
end

module Spree
  class Digital < ActiveRecord::Base
    belongs_to :variant
    has_many :digital_links, :dependent => :destroy

    has_attached_file :attachment, :path => ":rails_root/private/digitals/:id/:basename.:extension"
    validates_attachment_content_type :attachment, :content_type => %w(audio/mpeg application/x-mobipocket-ebook application/epub+zip application/pdf application/zip image/jpeg)

    if Paperclip::Attachment.default_options[:storage] == :s3
      attachment_definitions[:attachment][:s3_permissions] = :private
      attachment_definitions[:attachment][:s3_headers] = { :content_disposition => 'attachment' }
    end
  end
end

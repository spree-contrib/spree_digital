module Spree
  class Digital < ActiveRecord::Base
    belongs_to :variant
    has_many :digital_links, :dependent => :destroy

    has_attached_file :attachment, :path => ":rails_root/private/digitals/:id/:basename.:extension"

    include Spree::Core::S3Support
    supports_s3 :attachment

    #TODO: merge this option into supports_s3 in Spree::Core::S3Support
    if Spree::Config[:use_s3]
      attachment_definitions[:attachment][:s3_permissions] = :private
      attachment_definitions[:attachment][:s3_headers] = { :content_disposition => 'attachment' }
    end



    # TODO: Limit the attachment to one single file. Paperclip supports many by default :/
    attr_accessible :variant_id, :attachment
  end
end

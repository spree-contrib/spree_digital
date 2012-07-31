module Spree
  class DigitalSample < ActiveRecord::Base
    belongs_to :variant
  
    has_attached_file :attachment, :path => ":rails_root/public/digital_samples/:id/:basename.:extension", 
                      :url => "/public/digital_samples/:id/:basename.:extension"
  
    # TODO: Limit the attachment to one single file. Paperclip supports many by default :/

    attr_accessible :variant_id, :attachment
      
  end
end
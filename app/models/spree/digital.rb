module Spree
  class Digital < ActiveRecord::Base
    belongs_to :variant
    has_many :digital_links, :dependent => :destroy
  
    has_attached_file :attachment, :path => ":rails_root/private/digitals/:id/:basename.:extension"
  
    # TODO: Limit the attachment to one single file. Paperclip supports many by default :/
      
  end
end
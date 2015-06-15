require 'fileutils'

module Spree
  class DigitalLink < ActiveRecord::Base
    belongs_to :digital
    validates :digital, :presence => true

    belongs_to :line_item

    belongs_to :user
    
    validates_length_of :secret, :is => 30
    validates_uniqueness_of :secret

    has_attached_file :attachment, path: ":rails_root/private/digitals/:digital_id/:basename.:extension"
    do_not_validate_attachment_file_type :attachment
    validates_attachment_presence :attachment
    
    before_validation :set_defaults, :on => :create

    before_save :copy_digital
    
    # Can this link stil be used? It is valid if it's less than 24 hours old and was not accessed more than 3 times
    def downloadable?
      !(expired? || access_limit_exceeded?)
    end

    def expired?
      SpreeDigital::Config[:expirable_links] && (self.created_at <= SpreeDigital::Config[:authorized_days].day.ago)
    end

    def access_limit_exceeded?
      SpreeDigital::Config[:expirable_links] && (self.access_counter >= SpreeDigital::Config[:authorized_clicks])
    end

    # This method should be called when a download is initiated.
    # It returns +true+ or +false+ depending on whether the authorization is granted.
    def download!
      downloadable? && increment!(:access_counter) ? true : false
    end

    def reset!
      update_column :access_counter, 0
      update_column :created_at, Time.now
    end

    def original_attachment
      self.digital.present? and self.digital.attachment
    end

    def attachment_file_name
      super || (SpreeDigital::Config[:per_user_attachment] ? [self.secret, self.original_attachment.original_filename].join('_') : self.original_attachment.original_filename)
    end

    def attachment_dir
      self.original_attachment.path.gsub(self.original_attachment.original_filename, '')
    end

    def attachment_alias
      SpreeDigital::Config[:per_user_attachment] ? self.attachment : self.original_attachment
    end

    private
    
    def copy_digital
      if SpreeDigital::Config[:per_user_attachment]
        begin
          FileUtils.cp(self.original_attachment.path, File.join(self.attachment_dir, self.attachment_file_name))
          self.attachment = File.open(File.join(self.attachment_dir, self.attachment_file_name))
        rescue => e
          logger.error "There was a problem copying file #{self.attachment_file_name} #{e}"
          return false
        end
      else
        return true
      end
    end

    # Populating the secret automatically and zero'ing the access_counter (otherwise it might turn out to be NULL)
    def set_defaults
      self.secret = SecureRandom.hex(15)
      self.access_counter ||= 0
    end
  end
end
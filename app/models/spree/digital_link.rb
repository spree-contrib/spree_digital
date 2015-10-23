require 'fileutils'

module Spree
  class DigitalLink < ActiveRecord::Base
    belongs_to :digital
    validates :digital, :presence => true
    delegate :variant, to: :digital
    
    belongs_to :line_item
    belongs_to :user

    validates_length_of :secret, :is => 30
    validates_uniqueness_of :secret
    
    has_attached_file :attachment, path: ":rails_root/private/digitals/:digital_id/:basename.:extension"
    do_not_validate_attachment_file_type :attachment
    # validates_attachment_presence :attachment
    attr_accessor :remove_attachment_file
    attr_accessor :regenerate_attachment_file

    before_validation :set_defaults, :on => :create
    before_save :copy_attachment_file!, if: :should_regenerate_attachment_file
    before_save :check_remove_attachment_file
    
    def should_regenerate_attachment_file
      self.new_record? || self.regenerate_attachment_file
    end

    def regenerate_attachment_file
      @regenerate_attachment_file || false
    end

    def regenerate_attachment_file=(value)
      @regenerate_attachment_file = value
    end

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
    # def copy_digital
    #   if SpreeDigital::Config[:per_user_attachment]
    #     begin
    #       new_copy = File.join(self.attachment_dir, self.attachment_file_name)
    #       if SpreeDigital::Config.per_user_attachment_process.present?
    #         puts "Executing Spree::Digital per_user_attachment_process..."
    #         SpreeDigital::Config.per_user_attachment_process.call(self.original_attachment.path, new_copy, self)
    #       else
    #         FileUtils.cp(self.original_attachment.path, new_copy)
    #       end
    #       self.attachment = File.open(new_copy)
    #     rescue => e
    #       logger.error "There was a problem copying file #{self.attachment_file_name} #{e}"
    #       return false
    #     end
    #   else
    #     return true
    #   end
    # end

    def copy_attachment_file!
      if SpreeDigital::Config[:per_user_attachment]
        begin
          new_copy = File.join(self.attachment_dir, self.attachment_file_name)
          if SpreeDigital::Config.per_user_attachment_process.present?
            puts "Executing Spree::Digital per_user_attachment_process..."
            SpreeDigital::Config.per_user_attachment_process.call(self.original_attachment.path, new_copy, self)
          else
            FileUtils.cp(self.original_attachment.path, new_copy)
          end
          self.attachment = File.open(new_copy)
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

    def check_remove_attachment_file
      if !SpreeDigital::Config[:keep_digitals] && self.remove_attachment_file.eql?(1)
        begin
          FileUtils.rm(self.attachment.path) 
        rescue => e
          logger.error "There was a problem deleting file #{self.attachment_file_name} #{e}"
          return false
        end
        return true
      end
    end

  end
end
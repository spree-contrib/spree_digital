module Spree
  module Downloadable
    def show
      if attachment.present?
        # don't authorize the link unless the file exists
        # the logger error will help track down customer issues easier
        if attachment_is_file?
          if authorized?
            if Paperclip::Attachment.default_options[:storage] == :s3
              redirect_to attachment.expiring_url(Spree::DigitalConfiguration[:s3_expiration_seconds]) and return
            else
              send_file attachment.path, filename: attachment.original_filename, type: attachment.content_type, status: :ok and return
            end
          end
        else
          Rails.logger.error "Missing Digital Item: #{attachment.path}"
        end
      end

      unauthorized_action
    end
  
    private

      def unauthorized_action
      end

      def attachment_is_file?
        if Paperclip::Attachment.default_options[:storage] == :s3
          attachment.exists?
        else
          File.file?(attachment.path)
        end
      end
  end
end

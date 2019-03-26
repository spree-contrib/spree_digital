module Spree
  class DigitalsController < Spree::StoreController
    def show
      if attachment.present?
        # don't authorize the link unless the file exists
        # the logger error will help track down customer issues easier
        if attachment_is_file?
          if digital_link.authorize!
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

      render :unauthorized
    end

    private

    def attachment_is_file?
      if Paperclip::Attachment.default_options[:storage] == :s3
        attachment.exists?
      else
        File.file?(attachment.path)
      end
    end

    def digital_link
      @link ||= DigitalLink.find_by!(secret: params[:secret])
    end

    def attachment
      @attachment ||= digital_link.digital.try(:attachment) if digital_link.present?
    end
  end
end

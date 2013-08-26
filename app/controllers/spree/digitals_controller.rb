module Spree
  class DigitalsController < Spree::StoreController
    ssl_required :show
    rescue_from ActiveRecord::RecordNotFound, with: :resource_not_found

    def show
      if attachment.present?
        # don't authorize the link unless the file exists
        # the logger error will help track down customer issues easier

        # TODO: PMG - We should probably be a little more sophisticated here, and support
        # remote files (e.g. S3)
        if attachment_is_file?
          if digital_link.authorize!
            file_sent = send_file attachment.path, 
                                  :filename => attachment.original_filename, 
                                  :type => attachment.content_type
            return if file_sent
          end
        else
          Rails.logger.error "Missing Digital Item: #{attachment.path}"
        end
      end

      render :unauthorized
    end
 
    def attachment_is_file?
      File.file?(attachment.path)
    end

    private
      def digital_link
        @link ||= DigitalLink.find_by_secret(params[:secret])
        raise ActiveRecord::RecordNotFound if @link.nil?
        @link
      end

      def attachment
        @attachment ||= digital_link.digital.try(:attachment) if digital_link.present?
      end

      def resource_not_found
        head status: 404
      end

  end
end

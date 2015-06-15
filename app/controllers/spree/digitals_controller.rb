module Spree
  class DigitalsController < Spree::StoreController
    force_ssl only: :show, if: :ssl_configured?
    rescue_from ActiveRecord::RecordNotFound, with: :resource_not_found
    before_action :authenticate_user!, if: Proc.new { SpreeDigital::Config[:authentication_required] }

    def show
      if attachment.present? && attachment_is_file?
        # don't authorize the link unless the file exists
        # the logger error will help track down customer issues easier
        if authorize_download! && digital_link.downloadable? 
          if Paperclip::Attachment.default_options[:storage] == :s3
            redirect_to attachment.expiring_url(Spree::DigitalConfiguration[:s3_expiration_seconds]) and return
          else
            send_file attachment.path, :filename => attachment.original_filename, :type => attachment.content_type and return
          end
        end
      else
        flash[:error] = 'Se ha producido un error intentando descargar el fichero. Por favor, intentálo de nuevo.'
        Rails.logger.error "Missing Digital Item: #{attachment.path}"
      end

      render :unauthorized
    end

    def spree_current_user
      current_user
    end
    helper_method :spree_current_user

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
        @attachment ||= digital_link.try(:attachment) if digital_link.present?
      end

      def resource_not_found
        head status: 404
      end

      def ssl_configured?
        Rails.env.production?
      end

      def authorize_download!
        !SpreeDigital::Config[:authentication_required] || !SpreeDigital::Config[:authorization_required] || authorize!(:download, digital_link)
      end
  end
end

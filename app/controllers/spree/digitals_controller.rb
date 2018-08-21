module Spree
  class DigitalsController < Spree::StoreController
    #force_ssl only: :show, if: :ssl_configured?
    rescue_from ActiveRecord::RecordNotFound, with: :resource_not_found
    skip_before_filter :require_no_authentication, if: Proc.new { SpreeDigital::Config[:authentication_required] }

    def show
      if attachment.present? 
        if attachment_file_present?
          authorize_and_send_file!
        else
          if digital_link.regenerate_attachment_file = true and digital_link.save
            Rails.logger.info "Digital link #{attachment.path} regenerated"
            authorize_and_send_file!
          else
            Rails.logger.error "Error generating file: #{attachment.path} #{digital_link.inspect}"
            redirect_to :back, error: Spree.t('error_in_attachment', scope: 'digitals') and return
          end
        end
      else
        Rails.logger.error "Missing Digital Item: #{attachment.path}"
        redirect_to :back, error: Spree.t('error_in_attachment', scope: 'digitals') and return
      end
    end

    private

      def attachment_file_present?
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

      def authorize_and_send_file!
        if authorize_download! && digital_link.downloadable? 
          if Paperclip::Attachment.default_options[:storage] == :s3
            redirect_to attachment.expiring_url(Spree::DigitalConfiguration[:s3_expiration_seconds]) and return
          else
	    response.headers['Content-Length'] = attachment.size.to_s
            send_file attachment.path, :filename => attachment.original_filename, :type => attachment.content_type and return
          end
        else
          render :unauthorized
        end
      end
  end
end

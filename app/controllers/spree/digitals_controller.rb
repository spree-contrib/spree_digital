module Spree
  class DigitalsController < Spree::StoreController
    include Downloadable

    rescue_from ActiveRecord::RecordNotFound, with: :render_404

    private

      def digital_link
        @link ||= DigitalLink.find_by!(secret: params[:secret])
      end

      def authorized?
        digital_link.authorize!
      end
    
      def unauthorized_action
        render :unauthorized
      end

      def attachment
        @attachment ||= digital_link.digital.try(:attachment) if digital_link.present?
      end
  end
end

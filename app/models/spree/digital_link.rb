module Spree
  class DigitalLink < ActiveRecord::Base
    
    belongs_to :digital
    belongs_to :line_item
    
    validates_length_of :secret, :is => 30
    validates :digital, :presence => true
    
    before_validation :set_defaults, :on => :create
    
    # Can this link stil be used? It is valid if it's less than 24 hours old and was not accessed more than 3 times
    # The part after the or allows a logged in user to download for as long as the order still displays in their account
    def authorizable?
      (self.created_at > Spree::DigitalConfiguration[:authorized_days].day.ago and self.access_counter < Spree::DigitalConfiguration[:authorized_clicks]) or (self.line_item.order.user == Spree::User.current)
    end
    
    # This method should be called when a download is initiated.
    # It returns +true+ or +false+ depending on whether the authorization is granted.
    def authorize!
      authorizable? && increment!(:access_counter) ? true : false
    end
    
    private
    
    # Populating the secret automatically and zero'ing the access_counter (otherwise it might turn out to be NULL)
    def set_defaults
      self.secret = SecureRandom.hex(15)
      self.access_counter = 0
    end

    attr_accessible :digital, :line_item, :secret

  end
end
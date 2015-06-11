module Spree
  class DigitalAbility
    include CanCan::Ability

    def initialize(user)
      user ||= Spree.user_class.new

      alias_action :create, :update, :destroy, :read, to: :download
      can :download, Spree::DigitalLink, user_id: user.id
    end
  end
end  

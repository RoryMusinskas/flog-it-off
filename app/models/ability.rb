# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, Collection

    if user.present?
      if user.seller?
        can :create, Collection
        can :update, Collection, seller_id: user.id
        can :destroy, Collection, seller_id: user.id
      end
    end
  end
end

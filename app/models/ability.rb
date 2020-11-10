# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    can :read, Collection, public: true

    can :read, Collection if user.buyer?
    if user.seller?
      can :read, Collection
      can :create, Collection
      can :update, Collection, seller_id: user.id
      can :destroy, Collection, seller_id: user.id
    end
  end
end

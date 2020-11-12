class AccountController < ApplicationController
  prepend_view_path(File.join(Rails.root, 'app/views/account/'))
  layout 'application'
  def profile
    @seller_completed_collections = Payment.where(seller_id: current_user.id)
    @buyer_completed_collections = Payment.where(buyer_id: current_user.id)
  end
end

class PaymentsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:webhook]

  def success
  end

  def webhook
    payment_id = params[:data][:object][:payment_intent]
    payment = Stripe::PaymentIntent.retrieve(payment_id)
    collection_id = payment.metadata.collection_id
    user_id = payment.metadata.user_id
    p "Event id " + collection_id
    p "User id " + user_id
    render plain: "Success"
  end
end


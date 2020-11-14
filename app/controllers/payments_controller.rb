class PaymentsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:webhook]

  def webhook
    payment_id = params[:data][:object][:payment_intent]
    payment = Stripe::PaymentIntent.retrieve(payment_id)
    collection_id = payment.metadata.collection_id
    buyer_id = payment.metadata.buyer_id
    seller_id = payment.metadata.seller_id
    amount_total = params[:data][:object][:amount_total]
    currency = params[:data][:object][:currency]
    payment_status = params[:data][:object][:payment_status]
    render plain: 'Success'
    Payment.create collection_id: collection_id, buyer_id: buyer_id, seller_id: seller_id, amount_total: amount_total, currency: currency, payment_status: payment_status
  end

  def free_collection
    collection_id = params[:collection][:id]
    seller_id = params[:collection][:seller_id]
    amount_total = params[:collection][:price]
    buyer_id = params[:buyer][:id]
    Payment.create collection_id: collection_id, buyer_id: buyer_id, seller_id: seller_id, amount_total: 'free', payment_status: 'paid'
    redirect_to payments_success_path
  end
end

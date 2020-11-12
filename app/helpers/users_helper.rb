module UsersHelper
  def stripe_button_link
    stripe_url = 'https://connect.stripe.com/express/oauth/authorize'
    redirect_uri = stripe_connect_path
    client_id =  Rails.application.credentials.dig(:stripe, :connect_client_id)

    "#{stripe_url}?redirect_uri=#{redirect_uri}&client_id=#{client_id}"
  end
end

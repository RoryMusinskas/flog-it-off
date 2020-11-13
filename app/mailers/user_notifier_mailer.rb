class UserNotifierMailer < ApplicationMailer
  default from: 'devrorym@gmail.com'
  # send a signup email to the user, pass in the user object that   contains the user's email address
  def send_signup_email(_user)
    @user = current_user
    mail(to: @user.email, subject: 'Thanks for signing up to flog it off')
  end
end

class UserNotifierMailer < ApplicationMailer
  default from: 'devrorym@gmail.com'
  # send a signup email to the user, pass in the user object that   contains the user's email address
  def send_signup_email
    @user = current_user
    mail(to: @user.email, subject: 'Thanks for signing up to flog it off')
  end

  def send_collection_new_mail(user)
    @user = user
    mail(to: @user.email, subject: 'Your collection has been created')
  end
end

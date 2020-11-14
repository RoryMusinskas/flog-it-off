class ApplicationMailer < ActionMailer::Base
  default from: 'support@flog-it-off.herokuapp.com'
  layout 'mailer'
end

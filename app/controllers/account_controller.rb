class AccountController < ApplicationController
  prepend_view_path(File.join(Rails.root, 'app/views/account/'))
  layout 'application'
  def profile; end
end

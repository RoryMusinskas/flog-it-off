class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  around_action :set_time_zone, if: :current_user

  # Redirect user and add excepiton message when the try to access a page they aren't authorized to
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end

  def after_sign_in_path_for(_resource)
    collections_path
  end

  protected

  # Sanitizing Devise sign up data
  def configure_permitted_parameters
    # devise params for sign up
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[role first_name last_name time_zone])
    # devise params for updating account
    devise_parameter_sanitizer.permit(:account_update, keys: %i[role first_name last_name time_zone])
  end

  def set_time_zone(&block)
    Time.use_zone(current_user.time_zone, &block)
  end
end

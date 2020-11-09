class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  around_action :set_time_zone, if: :current_user

  def after_sign_in_path_for(_resoure)
    collections_path
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:role, :first_name, :last_name, :time_zone])
  end

  def set_time_zone(&block)
    Time.use_zone(current_user.time_zone, &block)
  end
end

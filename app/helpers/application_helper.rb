module ApplicationHelper
  def app_name
    Rails.application.class.module_parent_name
  end
end

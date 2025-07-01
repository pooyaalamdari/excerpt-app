# app/controllers/application_controller.rb

class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # اضافه کردن این خط
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  # اضافه کردن این متد
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :avatar])
  end
end
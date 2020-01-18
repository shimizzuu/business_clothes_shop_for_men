class ApplicationController < ActionController::Base
  include Spree::Core::ControllerHelpers::Order
  include Spree::Core::ControllerHelpers::Store
  include Spree::Core::ControllerHelpers::PaymentParameters
  include Spree::Core::ControllerHelpers::Auth
  include Spree::Core::ControllerHelpers::StrongParameters
  protect_from_forgery with: :exception
end

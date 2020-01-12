class Potepan::OrdersController < ApplicationController
  # Shows the current incomplete order from the session
  def edit
    @order = Spree::Order.incomplete.find_or_initialize_by(
      guest_token: cookies.signed[:guest_token]
    )
  end
end

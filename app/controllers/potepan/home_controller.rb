class Potepan::HomeController < ApplicationController
  MAXIMUM_NUMBER_OF_NEW_RELEASED_PRODUCTS = 8

  def index
    @new_products = Spree::Product.
      where("available_on > ?", 1.month.ago).
      order(available_on: :desc).
      limit(MAXIMUM_NUMBER_OF_NEW_RELEASED_PRODUCTS)
  end
end

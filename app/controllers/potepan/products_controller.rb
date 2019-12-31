class Potepan::ProductsController < ApplicationController
  MAXIMUM_NUMBER_OF_RELATED_PRODUCTS = 4

  def show
    @product = Spree::Product.find(params[:id])
    @images = @product.images
    @related_products = Spree::Product.related_products(@product).limit(MAXIMUM_NUMBER_OF_RELATED_PRODUCTS)
  end
end

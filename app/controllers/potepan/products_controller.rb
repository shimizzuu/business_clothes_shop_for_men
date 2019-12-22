class Potepan::ProductsController < ApplicationController
  MAX_RELATED_PRODUCTS_GET_FROM_DB = 4

  def show
    @product = Spree::Product.find(params[:id])
    @images = @product.images
    @related_products = Spree::Product.related_products(@product).limit(MAX_RELATED_PRODUCTS_GET_FROM_DB)
  end
end

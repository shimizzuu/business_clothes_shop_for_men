class Potepan::ProductsController < ApplicationController
  MAX_RELATED_PRODUCTS_GET_FROM_DB = 4

  def show
    @product = Spree::Product.find(params[:id])
    @images = @product.images
    @related_products = Spree::Product.
      in_taxons(@product.taxons).
      includes(master: [:images, :default_price]).
      where.not(id: @product.id).
      distinct.
      limit(MAX_RELATED_PRODUCTS_GET_FROM_DB)
  end
end

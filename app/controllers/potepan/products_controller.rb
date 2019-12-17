class Potepan::ProductsController < ApplicationController
  RELATED_ITEMS_DISPLAYED = 4

  def show
    @product = Spree::Product.find(params[:id])
    @images = @product.images
    @related_products = Spree::Product.
      in_taxons(@product.taxons).
      includes(master: [:images, :default_price]).
      where.not(id: @product.id).
      distinct.
      limit(RELATED_ITEMS_DISPLAYED)
  end
end

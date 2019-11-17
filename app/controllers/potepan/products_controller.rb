class Potepan::ProductsController < ApplicationController
  def show
    @product = Spree::Product.find(params[:id])
    @image = @product.images
    render 'products/show'
  end
end

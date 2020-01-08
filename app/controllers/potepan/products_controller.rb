class Potepan::ProductsController < ApplicationController
  MAXIMUM_NUMBER_OF_RELATED_PRODUCTS = 4

  def show
    @product = Spree::Product.find(params[:id])
    @images = @product.images
    @related_products = Spree::Product.related_products(@product).limit(MAXIMUM_NUMBER_OF_RELATED_PRODUCTS)
  end

  def search
    @keywords = params[:keywords]

    if @keywords.blank?
      @products = []
    else
      @products = Spree::Product.
        where("spree_products.name LIKE :keyword", keyword: "%#{ActiveRecord::Base.sanitize_sql_like(@keywords)}%").
        or(Spree::Product.
        where("spree_products.description LIKE :keyword", keyword: "%#{ActiveRecord::Base.sanitize_sql_like(@keywords)}%")).
        includes(master: [:default_price, :images])
    end
  end
end

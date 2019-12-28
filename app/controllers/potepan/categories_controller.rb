class Potepan::CategoriesController < ApplicationController
  def show
    @categories = Spree::Taxonomy.includes(:taxons)
    @taxon = Spree::Taxon.find(params[:id])
    @products = @taxon.all_products.includes(master: [:images, :default_price])
    respond_to do |format|
      format.html
      format.js
    end
  end
end

class Potepan::CategoriesController < ApplicationController
  def show
    # サイドバーに表示するカテゴリー情報の取得
    @categories = Spree::Taxonomy.includes(:taxons)

    # 表示する商品情報の取得
    @taxon = Spree::Taxon.find(params[:id])
    @products = @taxon.all_products.includes(master: [:images, :default_price])
  end
end

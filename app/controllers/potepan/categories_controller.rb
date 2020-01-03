class Potepan::CategoriesController < ApplicationController
  def show
    # サイドバー情報取得
    @categories = Spree::Taxonomy.includes(:taxons)
    # FILTER_BY_OPTION
    @colors = Spree::OptionType.find_by(presentation: "Color").option_values
    @sizes = Spree::OptionType.find_by(presentation: "Size").option_values
    # 商品取得
    @taxon = Spree::Taxon.find(params[:id])
    @products = @taxon.all_products.includes(master: [:images, :default_price])

    # URLクエリ
    if params[:option_id]
      option_id = params[:option_id]
      @variants = Spree::Variant.
        joins(:option_values).
        includes(:product, :default_price, :images).
        where(product_id: @products.ids).
        where("spree_option_values.id": option_id)
    end

    respond_to do |format|
      format.html
      format.js
    end
  end
end

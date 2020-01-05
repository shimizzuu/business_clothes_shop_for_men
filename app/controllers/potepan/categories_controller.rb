class Potepan::CategoriesController < ApplicationController
  def show
    # サイドバー情報取得
    @categories = Spree::Taxonomy.includes(:taxons)
    # FILTER_BY_OPTION
    @colors = Spree::OptionType.find_by(presentation: "Color").option_values
    @sizes = Spree::OptionType.find_by(presentation: "Size").option_values
    # 商品取得
    @taxon = Spree::Taxon.find(params[:id])
    sort_type = params[:sort_type] || "new_to_old"
    @products = Spree::Product.
      on_taxon(@taxon).
      with_price_and_images.
      order_by(sort_type)

    # URLクエリ
    if params[:option_id]
      option_id = params[:option_id]
      @variants = Spree::Variant.
        on_products_with_option_id(@products, option_id).
        with_price_and_images.
        order_by(sort_type)
    end

    respond_to do |format|
      format.html
      format.js
    end
  end
end

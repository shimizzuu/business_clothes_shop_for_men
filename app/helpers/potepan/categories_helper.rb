module Potepan
  module CategoriesHelper
    def variants_count_on_option(option:, taxon:)
      Spree::Variant.
        joins(:option_values).
        where(product_id: taxon.products.ids).
        where("spree_option_values.id": option.id).
        count
    end
  end
end

module CategoriesHelper
  def variants_count_on_option(option:, taxon:)
    Spree::Variant.
      joins(:option_values).
      where(produt_id: taxon.products.ids).
      where("spree_option_values.id": option.id).
      count
  end
end

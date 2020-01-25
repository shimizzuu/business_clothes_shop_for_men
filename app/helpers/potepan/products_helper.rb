module Potepan
  module ProductsHelper
    include Spree::ProductsHelper

    def select_box_of_variant(product)
      if product.has_variants?
        select_tag(:variant_id, options_from_collection_for_select(product.variants_and_option_values_for, :id, :options_text))
      else
        hidden_field_tag(:variant_id, product.master.id)
      end
    end
  end
end

require 'rails_helper'
RSpec.describe Spree::Product, type: :model do
  describe "scope" do
    describe "related_products" do
      before do
        taxonomy_1 = create(:taxonomy, name: "Categories")
        taxonomy_2 = create(:taxonomy, name: "Brands")
        product_taxon = create(:taxon, taxonomy: taxonomy_1)
        product_taxon_category = create(:taxon, taxonomy: taxonomy_2)
        other_product = create(:taxon)
        @product = create(:product, taxons: [product_taxon, product_taxon_category])
        @related_product = create(:product, taxons: [product_taxon])
        @related_product_same_category = create(:product, taxons: [product_taxon_category])
        @other_product = create(:product, taxons: [other_product])
      end

      it "returns returns related_products" do
        expect(Spree::Product.related_products(@product)).to include @related_product, @related_product_same_category
      end

      it "does not return related_products" do
        expect(Spree::Product.related_products(@product)).not_to include @other_product
      end
    end
  end
end

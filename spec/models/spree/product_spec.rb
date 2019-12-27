require 'rails_helper'
RSpec.describe Spree::Product, type: :model do
  describe "scope" do
    describe "related_products" do
      let(:taxonomy_1) { create :taxonomy, name: "Categories" }
      let(:taxonomy_2) { create :taxonomy, name: "Brands" }
      let(:taxon_taxonomy_1) { create :taxon, taxonomy: taxonomy_1 }
      let(:taxon_taxonomy_2) { create :taxon, taxonomy: taxonomy_2 }
      let(:taxon_other_taxonomy) { create :taxon }
      let(:product) { create :product, taxons: [taxon_taxonomy_1, taxon_taxonomy_2] }
      let(:related_product_1) { create :product, taxons: [taxon_taxonomy_1] }
      let(:related_product_2) { create :product, taxons: [taxon_taxonomy_2] }
      let(:other_product) { create :product, taxons: [taxon_other_taxonomy] }

      it "returns returns related_products" do
        expect(Spree::Product.related_products(product)).to include related_product_1, related_product_2
      end

      it "does not return related_products" do
        expect(Spree::Product.related_products(product)).not_to include other_product
      end
    end
  end
end

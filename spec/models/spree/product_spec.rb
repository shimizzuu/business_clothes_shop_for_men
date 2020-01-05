require 'rails_helper'
RSpec.describe Spree::Product, type: :model do
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

    it "returns related_products" do
      expect(Spree::Product.related_products(product)).to include related_product_1, related_product_2
    end

    it "does not return other_products" do
      expect(Spree::Product.related_products(product)).not_to include other_product
    end
  end

  describe "scope" do
    describe "並び替え" do
      let(:newest_cheap_product) { create :product, available_on: Time.zone.now, price: 100 }
      let(:new_cheapest_product) { create :product, available_on: 1.week.ago, price: 50 }
      let(:old_most_expensive_product) { create :product, available_on: 2.weeks.ago, price: 200 }
      let(:oldest_expensive_product) { create :product, available_on: 3.weeks.ago, price: 150 }

      context "order_by_price_asc" do
        it "価格が安い順に返す" do
          expect(Spree::Product.order_by_price_asc).to eq [
            new_cheapest_product,
            newest_cheap_product,
            oldest_expensive_product,
            old_most_expensive_product
          ]
        end
      end

      context "order_by_price_desc" do
        it "価格が高い順に返す" do
          expect(Spree::Product.order_by_price_desc).to eq [
            old_most_expensive_product,
            oldest_expensive_product,
            newest_cheap_product,
            new_cheapest_product
          ]
        end
      end

      context "order_by_new_to_old" do
        it "available_onが新しい順に返す" do
          expect(Spree::Product.order_by_new_to_old).to eq [
            newest_cheap_product,
            new_cheapest_product,
            old_most_expensive_product,
            oldest_expensive_product
          ]
        end
      end

      context "order_by_new_to_old" do
        it "available_onが古い順に返す" do
          expect(Spree::Product.order_by_old_to_new).to eq [
            oldest_expensive_product,
            old_most_expensive_product,
            new_cheapest_product,
            newest_cheap_product
          ]
        end
      end

      context ".order_by()" do
        it "指定したスコープを使用する" do
          expect(Spree::Product.order_by("price_desc")).to eq Spree::Product.order_by_price_desc
        end
      end
    end
  end
end

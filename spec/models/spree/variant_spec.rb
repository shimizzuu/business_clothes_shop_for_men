require 'rails_helper'
RSpec.describe Spree::Variant, type: :model do
  describe "scope" do
    describe "並び替え" do
      let(:newest_cheap_product) { create :product, available_on: Time.zone.now, price: 100 }
      let(:new_cheapest_product) { create :product, available_on: 1.week.ago, price: 50 }
      let(:old_most_expensive_product) { create :product, available_on: 2.weeks.ago, price: 200 }
      let(:oldest_expensive_product) { create :product, available_on: 3.weeks.ago, price: 150 }

      context "order_by_price_asc" do
        it "価格が安い順に返す" do
          expect(Spree::Variant.order_by_price_asc).to eq [
            new_cheapest_product.master,
            newest_cheap_product.master,
            oldest_expensive_product.master,
            old_most_expensive_product.master
          ]
        end
      end

      context "order_by_price_desc" do
        it "価格が高い順に返す" do
          expect(Spree::Variant.order_by_price_desc).to eq [
            old_most_expensive_product.master,
            oldest_expensive_product.master,
            newest_cheap_product.master,
            new_cheapest_product.master
          ]
        end
      end

      context "order_by_new_to_old" do
        it "available_onが新しい順に返す" do
          expect(Spree::Variant.order_by_new_to_old).to eq [
            newest_cheap_product.master,
            new_cheapest_product.master,
            old_most_expensive_product.master,
            oldest_expensive_product.master
          ]
        end
      end

      context "order_by_new_to_old" do
        it "available_onが古い順に返す" do
          expect(Spree::Variant.order_by_old_to_new).to eq [
            oldest_expensive_product.master,
            old_most_expensive_product.master,
            new_cheapest_product.master,
            newest_cheap_product.master
          ]
        end
      end

      context ".order_by()" do
        it "指定したスコープを使用する" do
          expect(Spree::Variant.order_by("price_desc")).to eq Spree::Variant.order_by_price_desc
        end
      end
    end
  end
end

require 'rails_helper'
RSpec.describe Potepan::Categories, type: :request do
  describe 'GET #show' do
    let(:taxonomy) { create :taxonomy }
    let(:taxon) { create :taxon, taxonomy: taxonomy }
    let!(:product) { create :product, taxons: [taxon] }
    let!(:other_product) { create :product }
    let!(:option_color) { create :option_type, presentation: "Color" }
    let!(:red) { create :option_value, presentation: "Red", option_type: option_color }
    let!(:blue) { create :option_value, presentation: "Blue", option_type: option_color }
    let!(:products_red_variant) { create :variant, option_values: [red], product: product }
    let!(:products_blue_variant) { create :variant, option_values: [blue], product: product }
    let!(:other_products_red_variant) { create :variant, option_values: [red], product: other_product }
    let!(:option_size) { create :option_type, presentation: "Size" }
    let!(:large) { create :option_value, presentation: "Large", option_type: option_size }
    let!(:medium) { create :option_value, presentation: "Medium", option_type: option_size }
    let!(:products_large_variant) { create :variant, option_values: [large], product: product }
    let!(:products_medium_variant) { create :variant, option_values: [medium], product: product }
    let!(:other_products_large_variant) { create :variant, option_values: [large], product: other_product }

    context "商品カテゴリーで絞り込みしたとき" do
      before do
        get potepan_category_path(taxon.id)
      end

      it { expect(response.status).to eq 200 }

      it "カテゴリー名が表示されていること" do
        expect(response.body).to include taxon.name
      end

      it "カテゴリーに属する商品のみが表示されていること" do
        expect(response.body).to include product.name
        expect(response.body).not_to include other_product.name
      end
    end

    context "カラーで絞り込みしたとき" do
      before do
        get potepan_category_path(taxon.id, option_id: red.id)
      end

      it { expect(response.status).to eq 200 }

      it "カテゴリー名が表示されていること" do
        expect(response.body).to include taxon.name
      end

      it "絞り込みしたカラーの商品のみが表示されていること" do
        expect(response.body).to include products_red_variant.name
        expect(response.body).not_to include other_products_red_variant.name
      end
    end

    context "サイズで絞り込みしたとき" do
      before do
        get potepan_category_path(taxon.id, option_id: large.id)
      end

      it { expect(response.status).to eq 200 }

      it "カテゴリー名が表示されていること" do
        expect(response.body).to include taxon.name
      end

      it "絞り込みしたサイズの商品のみが表示されていること" do
        expect(response.body).to include products_large_variant.name
        expect(response.body).not_to include other_products_large_variant.name
      end
    end
  end
end

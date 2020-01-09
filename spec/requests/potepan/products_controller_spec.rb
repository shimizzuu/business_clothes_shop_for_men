require 'rails_helper'
RSpec.describe Potepan::ProductsController, type: :request do
  describe '#show' do
    let(:taxonomy) { create :taxonomy }
    let(:taxon) { create :taxon, taxonomy: taxonomy }
    let(:product) { create :product, taxons: [taxon] }
    let!(:product_same_taxon) { create_list(:product, 5, taxons: [taxon]) }

    before do
      get potepan_product_path(product.id)
    end

    it { expect(response.status).to eq 200 }

    it "商品名が表示されていること" do
      expect(response.body).to include product.name
    end

    it "1-4つ目の関連商品が表示されていて5つ目の関連商品が表示されていないこと" do
      expect(response.body).to include product_same_taxon[0].name
      expect(response.body).to include product_same_taxon[1].name
      expect(response.body).to include product_same_taxon[2].name
      expect(response.body).to include product_same_taxon[3].name
      expect(response.body).not_to include product_same_taxon[4].name
    end

    it "「一覧ページへ戻る」のリンクが表示されていること" do
      expect(response.body).to include potepan_category_path(taxon.id)
    end
  end

  describe '#search' do
    let!(:product_with_in_name) { create :product, name: "Ruby-T" }
    let!(:product_with_in_description) { create :product, name: "T-shirt", description: "Ruby" }
    let!(:product_with_special_word_in_name) { create :product, name: "%Ruby%" }
    let!(:product_without_keyword) { create :product, name: "PHP", description: "PHP" }

    it "検索した商品が表示されていること" do
      get search_potepan_products_path(keywords: 'Ruby')
      expect(response.body).to include product_with_in_name.name
      expect(response.body).to include product_with_in_description.name
      expect(response.body).to include product_with_special_word_in_name.name
      expect(response.body).not_to include product_without_keyword.name
    end

    it "検索対象でない商品が表示されないこと、No resultsが表示されること" do
      get search_potepan_products_path(keywords: '')
      expect(response.body).not_to include product_without_keyword.name
      expect(response.body).to include "No results"
    end
  end
end

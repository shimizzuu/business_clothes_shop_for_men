require 'rails_helper'
RSpec.describe Potepan::ProductsController, type: :request do
  describe 'GET #show' do
    let(:taxonomy_1) { create :taxonomy, name: 'Categories' }
    let(:taxon_1) { create :taxon, taxonomy: taxonomy_1 }
    let(:product) { create :product, taxons: [taxon_1] }
    let!(:product_same_taxon) { create_list(:product, 5, taxons: [taxon_1]) }

    before do
      get potepan_product_path(id: product.id)
    end

    it { expect(response.status).to eq 200 }

    it "商品名が表示されていること" do
      expect(response.body).to include product.name
    end

    it "1-4つ目の関連商品が表示されていて5つ目の関連商品が表示されていないこと" do
      expect(response.body).to include product_same_taxon[0].name.upcase
      expect(response.body).to include product_same_taxon[1].name.upcase
      expect(response.body).to include product_same_taxon[2].name.upcase
      expect(response.body).to include product_same_taxon[3].name.upcase
      expect(response.body).not_to include product_same_taxon[4].name.upcase
    end

    it "「一覧ページへ戻る」のリンクが表示されていること" do
      expect(response.body).to include potepan_category_path(id: 1)
    end
  end
end

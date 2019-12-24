require 'rails_helper'
RSpec.describe Potepan::ProductsController, type: :controller do
  describe 'GET #show' do
    let(:taxonomy_1) { create :taxonomy, name: 'Categories' }
    let(:taxon_1) { create :taxon, taxonomy: taxonomy_1, parent_id: taxonomy_1.root.id }
    let!(:product) { create(:product, taxons: [taxon_1]) }
    let!(:product_same_taxon) { create_list(:product, 5, taxons: [taxon_1]) }

    before do
      get :show, params: { id: product.id }
    end

    it { expect(response.status).to eq 200 }

    it "productが取得できていること" do
      expect(assigns[:product]).to eq product
    end

    it "imageが取得できていること" do
      expect(assigns[:images]).to eq product.images
    end

    it "1-4つ目の関連商品が取得されていて5つ目の関連商品が取得されていないこと" do
      expect(assigns[:related_products]).to include product_same_taxon[0]
      expect(assigns[:related_products]).to include product_same_taxon[1]
      expect(assigns[:related_products]).to include product_same_taxon[2]
      expect(assigns[:related_products]).to include product_same_taxon[3]
      expect(assigns[:related_products]).not_to include product_same_taxon[4]
    end

    it "関連商品の取得個数が4つであること" do
      expect(assigns[:related_products].count).to eq 4
    end

    it "showページにリダイレクトされていること" do
      expect(response).to render_template :show
    end
  end
end

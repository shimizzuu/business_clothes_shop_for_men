require 'rails_helper'
RSpec.describe Potepan::ProductsController, type: :controller do
  describe 'GET #show' do
    let(:taxonomy_1) { create :taxonomy, name: 'Categories' }
    let(:taxon_1) { create :taxon, taxonomy: taxonomy_1, parent_id: taxonomy_1.root.id }
    let(:taxon_2) { create :taxon, taxonomy: taxonomy_1, parent_id: taxonomy_1.root.id }
    let!(:product) { create(:product, taxons: [taxon_1]) }
    let!(:product_same_taxon) { create(:product, taxons: [taxon_1]) }

    before do
      get :show, params: { id: product.id }
    end

    it "productが取得できていること" do
      expect(assigns[:product]).to eq product
    end

    it "imageが取得できていること" do
      expect(assigns[:images]).to eq product.images
    end

    it "関連商品が取得できていること" do
      expect(assigns[:related_products]).to include product_same_taxon
    end

    it "ステータスコード 200 OK確認" do
      expect(response.status).to eq 200
    end

    it "showページにリダイレクトされていること" do
      expect(response).to render_template :show
    end
  end
end

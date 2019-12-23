require 'rails_helper'
RSpec.describe Potepan::CategoriesController, type: :controller do
  describe 'GET #show' do
    let(:taxonomy) { create :taxonomy }
    let(:taxon) { create :taxon, taxonomy: taxonomy, parent_id: taxonomy.root.id }
    let(:product) { create :product, taxons: [taxon] }
    let(:other_product) { create :product }

    before do
      get :show, params: { id: taxon.id }
    end

    it{ expect(response.status).to eq 200 }

    it "カテゴリーページにリダイレクトされていること" do
      expect(response).to render_template :show
    end

    it 'assings @categories' do
      expect(assigns(:categories)).to include taxonomy
    end

    it "assigns @taxon" do
      expect(assigns(:taxon)).to eq taxon
    end

    it "assigns @products" do
      expect(assigns(:products)).to include product
    end

    it '@productsはother_productを含まない' do
      expect(assigns(:products)).not_to include other_product
    end
  end
end

require 'rails_helper'
RSpec.describe Potepan::CategoriesController, type: :request do
  describe 'GET #show' do
    let(:taxonomy) { create :taxonomy }
    let(:taxon) { create :taxon, taxonomy: taxonomy }
    let!(:product) { create :product, taxons: [taxon] }
    let!(:other_product) { create :product }

    before do
      get potepan_category_path(id: taxon.id)
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
end

require 'rails_helper'
RSpec.describe Potepan::ProductsController, type: :request do
  describe 'GET #show' do
    let(:taxonomy_1) { create :taxonomy, name: 'Categories' }
    let(:taxon_1) { create :taxon, taxonomy: taxonomy_1, parent_id: taxonomy_1.root.id }
    let(:product) { create :product, taxons: [taxon_1] }

    before do
      get potepan_product_path(id: product.id)
    end

    it { expect(response.status).to eq 200 }

    it "商品名が表示されていること" do
      expect(response.body).to include product.name
    end
  end
end

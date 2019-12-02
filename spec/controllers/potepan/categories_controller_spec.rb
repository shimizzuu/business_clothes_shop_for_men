require 'rails_helper'
RSpec.describe Potepan::CategoriesController, type: :controller do
  describe 'GET #show' do
    let(:taxonomy) { create :taxonomy }
    let(:taxon) { create :taxon, taxonomy: taxonomy, parent_id: taxonomy.root.id }

    before do
      get :show, params: { id: taxon.id }
    end

    it "ステータスコード 200 OK確認" do
      expect(response.status).to eq 200
    end

    it "カテゴリーページにリダイレクトされていること" do
      expect(response).to render_template :show
    end
  end
end

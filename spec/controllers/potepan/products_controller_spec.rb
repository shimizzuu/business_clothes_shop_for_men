require 'rails_helper'
RSpec.describe Potepan::ProductsController, type: :controller do
  describe 'GET #show' do
    let(:product_1) { create :product }

    before do
      get :show, params: { id: product_1.id }
    end

    it "productが取得できていること" do
      expect(assigns[:product]).to eq product_1
    end

    it "ステータスコード 200 OK確認" do
      expect(response.status).to eq 200
    end

    it "showページにリダイレクトされていること" do
      expect(response).to render_template :show
    end
  end
end

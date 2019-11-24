require 'rails_helper'

RSpec.describe Potepan::ProductsController, type: :controller do
  describe 'GET #show' do
    before do
      @product = create(:product)
      get :show, params: { id: @product.id }
    end

    it "@productが取得できていること" do
      expect(assigns[:product]).to eq @product
    end

    it "ステータスコード 200 OK確認" do
      expect(response.status).to eq 200
    end

    it "showページにリダイレクトされていること" do
      expect(response).to render_template :show
    end
  end
end

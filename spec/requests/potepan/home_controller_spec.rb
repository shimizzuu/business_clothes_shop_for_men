require 'rails_helper'
RSpec.describe Potepan::HomeController, type: :request do
  describe 'GET /potepan' do
    let(:new_product) { create :product, available_on: Time.zone.now }
    let(:old_product) { create :product, available_on: 1.year.ago }

    before do
      get potepan_root_path
    end

    it { expect(response.status).to eq 200 }

    it "新着商品のみが表示されていること" do
      within '.productCaption.clearfix' do
        expect(response.body).to include new_product.name
        expect(response.body).not_to include old_product.name
      end
    end
  end
end

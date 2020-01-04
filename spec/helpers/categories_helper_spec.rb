require 'rails_helper'
Rspec.describe CategoriesHelper do
  include CategoriesHelper

  describe "#variants_count_on_option" do
    let!(:taxon) { create :taxon }
    let!(:option_value) { create :option_value }
    let!(:other_option_value) { create :option_value }
    let!(:product) { create :product, taxons: [taxon] }
    let!(:other_product) { create :product }
    let!(:product_same_option_value) { create_list(:variant, 5, option_values: [option_value], product: product) }
    let!(:product_other_option_value) { create_list(:variant, 3, option_values: [other_option_value], product: product) }
    let!(:other_product_same_option_value) { create :variant, option_values: [option_value], product: other_product }

    it "選ばれたtaxonに紐付き、指定したoption_valueを持つvariantsの数を返す" do
      expect(variants_count_on_option(option: option_value, taxon: taxon)).to eq product_same_option_value.count
    end
  end
end

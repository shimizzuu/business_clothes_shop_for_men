require 'rails_helper'
RSpec.feature "Potepan::Categories", type: :feature do
  given(:taxonomy) { create :taxonomy }
  given(:taxon_1) { create :taxon, name: 'Bags', taxonomy: taxonomy, parent_id: taxonomy.root.id }
  given!(:taxon_2) { create :taxon, name: 'Mugs', taxonomy: taxonomy, parent_id: taxonomy.root.id }
  given!(:product) { create :product, taxons: [taxon_1] }
  given!(:product_same_taxon) { create :product, taxons: [taxon_1] }
  given!(:product_other_taxon) { create :product, taxons: [taxon_2] }

  given!(:option_color) { create :option_type, presentation: "Color" }
  given!(:red) { create :option_value, name: "Red", option_type: option_color }
  given!(:blue) { create :option_value, name: "Blue", option_type: option_color }
  given!(:products_red_variant) { create :variant, option_values: [red], product: product }
  given!(:products_blue_variant) { create :variant, option_values: [blue], product: product }
  given!(:other_products_red_variant) { create :variant, option_values: [red], product: product_other_taxon }

  given!(:option_size) { create :option_type, presentation: "Size" }
  given!(:large) { create :option_value, name: "Large", option_type: option_size }
  given!(:medium) { create :option_value, name: "Medium", option_type: option_size }
  given!(:products_L_variant) { create :variant, option_values: [large], product: product }
  given!(:products_M_variant) { create :variant, option_values: [medium], product: product }
  given!(:other_products_L_variant) { create :variant, option_values: [large], product: product_other_taxon }

  background do
    visit potepan_category_path(taxon_1.id)
  end

  scenario "タイトル表示/非表示確認" do
    expect(page).to have_title "#{taxon_1.name} - Rugged Style"
    expect(page).to have_content taxon_1.name.upcase
    expect(page).to have_no_content taxon_2.name.upcase
  end

  scenario "商品名表示/非表示確認" do
    expect(page).to have_content product.name
    expect(page).to have_content product_same_taxon.name
    expect(page).to have_no_content product_other_taxon.name
  end

  scenario "カテゴリーツリー表示確認" do
    within '.side-nav' do
      click_on taxonomy.name
      expect(page).to have_content "Bags"
      expect(page).to have_content "Mugs"
    end
  end

  scenario "商品詳細ページにレンダリングされるか確認" do
    within "#productsList" do
      click_on product.name
    end
    expect(page).to have_selector 'h2', text: product.name
  end

  scenario "カラー絞り込み表示確認" do
    click_on "Red"
    expect(page).to have_content products_red_variant.name
    expect(page).to have_no_content other_products_red_variant.name
  end

  scenario "サイズ絞り込み表示確認" do
    click_on "Large"
    expect(page).to have_content products_L_variant.name
    expect(page).to have_no_content other_products_L_variant.name
  end
end

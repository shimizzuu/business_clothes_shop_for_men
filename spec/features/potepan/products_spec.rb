require 'rails_helper'
RSpec.feature "Potepan::Products", type: :feature do
  given(:taxonomy_1) { create :taxonomy, name: 'Categories' }
  given(:taxonomy_2) { create :taxonomy, name: 'Brands' }
  given(:taxon_1) { create :taxon, taxonomy: taxonomy_1, parent_id: taxonomy_1.root.id }
  given(:taxon_2) { create :taxon, taxonomy: taxonomy_1, parent_id: taxonomy_1.root.id }
  given(:taxon_3) { create :taxon, taxonomy: taxonomy_2, parent_id: taxonomy_2.root.id }
  given(:product) { create :product, taxons: [taxon_1] }
  given!(:product_same_taxon) { create_list(:product, 5, taxons: [taxon_1]) }
  given!(:product_other_taxon) { create :product, taxons: [taxon_2] }
  given!(:product_other_taxonomy) { create :product, taxons: [taxon_3] }
  given!(:product_with_keyword) { create :product, name: "Ruby-T" }

  background do
    visit potepan_product_path(product.id)
  end

  scenario "関連商品の表示/非表示確認" do
    within '.row.productsContent' do
      expect(page).to have_content product_same_taxon[0].name
      expect(page).to have_content product_same_taxon[1].name
      expect(page).to have_content product_same_taxon[2].name
      expect(page).to have_content product_same_taxon[3].name
      expect(page).to have_no_content product_same_taxon[4].name
      expect(page).to have_no_content product_other_taxon.name
      expect(page).to have_no_content product_other_taxonomy.name
    end
  end

  scenario "表示中の商品が関連商品に表示されていないこと" do
    within '.row.productsContent' do
      expect(page).to have_no_content product.name
    end
  end

  scenario "関連商品をクリックすると関連商品の商品詳細ページを表示" do
    within '.row.productsContent' do
      click_on product_same_taxon[0].name
    end
    expect(page).to have_selector 'h2', text: product_same_taxon[0].name
  end

  scenario "ワード検索で正しい商品が検索できていること、空欄の場合はNo resultsと表示されること" do
    visit search_potepan_products_path(keywords: "Ruby")
    expect(page).to have_content("Ruby-T")
    visit search_potepan_products_path(keywords: "")
    expect(page).to have_content("No results")
  end
end

require 'rails_helper'
RSpec.feature "Potepan::Products", type: :feature do
  given(:taxonomy_1) { create :taxonomy, name: 'Categories' }
  given(:taxonomy_2) { create :taxonomy, name: 'Brands' }
  given(:taxon_1) { create :taxon, taxonomy: taxonomy_1, parent_id: taxonomy_1.root.id }
  given(:taxon_2) { create :taxon, taxonomy: taxonomy_1, parent_id: taxonomy_1.root.id }
  given(:taxon_3) { create :taxon, taxonomy: taxonomy_2, parent_id: taxonomy_2.root.id }
  given!(:product) { create(:product, taxons: [taxon_1]) }
  given!(:product_same_taxon) { create(:product, taxons: [taxon_1]) }
  given!(:product_other_taxon) { create(:product, taxons: [taxon_2]) }
  given!(:product_other_taxonomy) { create(:product, taxons: [taxon_3]) }

  background do
    visit potepan_product_path(id: product.id)
  end

  scenario "関連商品の表示/非表示確認" do
    within '.row.productsContent' do
      expect(page).to have_content product_same_taxon.name.upcase
      expect(page).to have_no_content product_other_taxon.name.upcase
      expect(page).to have_no_content product_other_taxonomy.name.upcase
    end
  end

  scenario "表示中の商品が関連商品に表示されていないこと" do
    within '.row.productsContent' do
      expect(page).to have_no_content product.name.upcase
    end
  end

  scenario "関連商品をクリックすると関連商品の商品詳細ページを表示" do
    within '.row.productsContent' do
      click_on(product_same_taxon.name.upcase)
    end
    expect(page).to have_selector 'h2', text: product_same_taxon.name.upcase
  end

  scenario "関連商品の商品詳細ページで元商品が表示されること" do
    visit potepan_product_path(id: product_same_taxon.id)
    expect(find('.row.productsContent')).to have_content product.name.upcase
  end
end

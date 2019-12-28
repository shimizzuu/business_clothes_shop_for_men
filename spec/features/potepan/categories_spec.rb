require 'rails_helper'
RSpec.feature "Potepan::Categories", type: :feature do
  given(:taxonomy) { create :taxonomy }
  given(:taxon_1) { create :taxon, name: 'Bags', taxonomy: taxonomy, parent_id: taxonomy.root.id }
  given!(:taxon_2) { create :taxon, name: 'Mugs', taxonomy: taxonomy, parent_id: taxonomy.root.id }
  given!(:product) { create :product, taxons: [taxon_1] }
  given!(:product_same_taxon) { create :product, taxons: [taxon_1] }
  given!(:product_other_taxon) { create :product, taxons: [taxon_2] }

  background do
    visit potepan_category_path(taxon_1.id)
  end

  scenario "タイトル表示/非表示確認" do
    expect(page).to have_title "#{taxon_1.name} - BIGBAG Store"
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
end

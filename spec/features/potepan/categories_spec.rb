require 'rails_helper'
RSpec.feature "Potepan::Categories", type: :feature do
  given(:taxonomy) { create :taxonomy, name: 'Category' }
  given(:taxon_1) { create :taxon, name: 'Bags', taxonomy: taxonomy, parent_id: taxonomy.root.id }
  given!(:taxon_2) { create :taxon, name: 'Mugs', taxonomy: taxonomy, parent_id: taxonomy.root.id }
  given!(:product_1) { create :product, taxons: [taxon_1] }
  given!(:product_2) { create :product, taxons: [taxon_1] }
  given!(:product_3) { create :product, taxons: [taxon_2] }

  background do
    visit potepan_category_path(id: taxon_1.id)
  end

  scenario "タイトル表示/非表示確認" do
    expect(page).to have_title "#{taxon_1.name} - BIGBAG Store"
    expect(page).to have_content taxon_1.name.upcase
    expect(page).to have_no_content taxon_2.name.upcase
  end

  scenario "商品名表示/非表示確認" do
    expect(page).to have_content product_1.name
    expect(page).to have_content product_2.name
    expect(page).to have_no_content product_3.name
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
      click_on product_1.name
    end
    expect(page).to have_selector 'h2', text: product_1.name
  end
end

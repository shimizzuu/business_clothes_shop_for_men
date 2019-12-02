require 'rails_helper'
RSpec.feature "Potepan::Categories", type: :feature do
  given!(:taxonomy) { create :taxonomy, name: 'Category' }

  given!(:taxon_1) { create :taxon, name: 'Bags', taxonomy: taxonomy, parent_id: taxonomy.root.id }
  given!(:taxon_2) { create :taxon, name: 'Mugs', taxonomy: taxonomy, parent_id: taxonomy.root.id }

  given!(:product_1) { create :product, taxons: [taxon_1] }
  given!(:product_2) { create :product, taxons: [taxon_1] }
  given!(:product_3) { create :product, taxons: [taxon_2] }

  background do
    visit potepan_category_path(id: taxon_1.id)
  end

  scenario "テンプレート表示確認" do
    expect(page).to have_title taxon_1.name
    expect(page).to have_selector 'h2', text: taxon_1.name.upcase
  end

  scenario "カテゴリーツリー表示確認" do
    within '.side-nav' do
      click_on taxonomy.name
      expect(page).to have_content "Bags"
      expect(page).to have_content "Mugs"
    end
  end

  scenario "toggle動作確認" do
    context "toggleを展開していない場合" do
      expect(find('a[data-target="#category-0"]')["aria-expanded"]).to be_falsey
    end
    context "toggleを展開した場合" do
      click_on taxonomy.name
      expect(find('a[data-target="#category-0"]')["aria-expanded"]).to be_truthly
    end
  end

  scenario "taxon_1の商品一覧表示確認" do
    within "#productsList" do
      taxon_1.products.each do |product|
        expect(page).to have_content product.name.upcase
      end
      taxon_2.products.each do |product|
        expect(page).to have_no_content product.name.upcase
      end
    end
  end

  scenario "商品詳細ページにレンダリングされるか確認" do
    within "#productsList" do
      click_on product_1.name
    end
    expect(page).to have_content product_1.name.upcase
  end

  scenario "taxon_2の商品一覧表示確認" do
    within ".side-nav" do
      click_on taxonomy.name
      click_on taxon_2.name
    end
    expect(page).to have_selector 'h2', text: taxon_2.name.upcase
    taxon_1.products.each do |product|
      expect(page).to have_no_content product.name.upcase
    end
    taxon_2.products.each do |product|
      expect(page).to have_content product.name.upcase
    end
  end
end

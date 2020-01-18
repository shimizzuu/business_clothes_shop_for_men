require 'rails_helper'
RSpec.feature "Potepan::Home", type: :feature do
  given!(:new_product) { create_list(:product, 9, available_on: Time.zone.now) }
  given!(:old_product) { create :product, available_on: 1.year.ago }

  background do
    visit potepan_root_path
  end

  scenario "新着商品の表示/非表示確認" do
    expect(page).to have_content new_product[0].name
    expect(page).to have_content new_product[1].name
    expect(page).to have_content new_product[2].name
    expect(page).to have_content new_product[3].name
    expect(page).to have_content new_product[4].name
    expect(page).to have_content new_product[5].name
    expect(page).to have_content new_product[6].name
    expect(page).to have_content new_product[7].name
    expect(page).to have_no_content new_product[8].name
    expect(page).to have_no_content old_product.name
  end
end

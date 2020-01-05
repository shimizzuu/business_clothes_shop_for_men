Spree::Variant.class_eval do
  scope :order_by_price_asc, -> do
    joins(:default_price).order("spree_prices.amount")
  end
  scope :order_by_price_desc, -> do
    joins(:default_price).order("spree_prices.amount desc")
  end
  scope :order_by_old_to_new, -> do
    joins(:product).order("spree_products.available_on asc")
  end
  scope :order_by_new_to_old, -> do
    joins(:product).order("spree_products.available_on desc")
  end
  scope :with_price_and_images, -> do
    includes(:product, :default_price, :images).order("spree_assets.position")
  end

  def self.on_option_id(option_id)
    joins(:option_values).where("spree_option_values.id": option_id)
  end

  def self.order_by(sort_type)
    try("order_by_#{sort_type}")
  end

  def self.on_products_with_option_id(products, option_id)
    on_option_id(option_id).where(product_id: products.ids)
  end
end

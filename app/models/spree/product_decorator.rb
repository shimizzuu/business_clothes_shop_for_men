Spree::Product.class_eval do
  scope :includes_master, -> { includes(master: [:images, :default_price]) }
  scope :related_products, -> (product) do
    in_taxons(product.taxons).
      includes_master.
      where.not(id: product.id).
      distinct
  end
  scope :order_by_price_asc, -> do
    joins(master: :default_price).order("spree_prices.amount")
  end
  scope :order_by_price_desc, -> do
    joins(master: :default_price).order("spree_prices.amount desc")
  end
  scope :order_by_old_to_new, -> { order(available_on: :asc) }
  scope :order_by_new_to_old, -> { order(available_on: :desc) }
  scope :with_price_and_images, -> do
    includes(master: [:default_price, :images]).order("spree_assets.position")
  end

  def self.on_taxon(taxon)
    joins(:taxons).where("spree_taxons.id": taxon.id)
  end

  def self.order_by(sort_type)
    try("order_by_#{sort_type}")
  end
end

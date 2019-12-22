Spree::Product.class_eval do
  scope :includes_master, -> { includes(master: [:images, :default_price]) }

  scope :related_products, -> (product) do
    Spree::Product.
      in_taxons(product.taxons).
      includes_master.
      where.not(id: product.id).
      distinct
  end
end

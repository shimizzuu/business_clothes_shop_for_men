class Potepan::OrdersController < ApplicationController
  before_action :store_guest_token
  before_action :assign_order, only: :update

  # Adds a new item to the order (creating a new order if none already exists)
  def create
    @order = current_order(create_order_if_necessary: true)
    variant = Spree::Variant.find(params[:variant_id])
    quantity = params[:quantity].present? ? params[:quantity].to_i : 1
    # 2,147,483,647 is crazy. See issue https://github.com/spree/spree/issues/2695.
    if !quantity.between?(1, 2_147_483_647)
      @order.errors.add(:base, t('spree.please_enter_reasonable_quantity'))
    end
    begin
      @line_item = @order.contents.add(variant, quantity)
    rescue ActiveRecord::RecordInvalid => error
      @order.errors.add(:base, error.record.errors.full_messages.join(", "))
    end
    if @order.errors.any?
      flash[:error] = @order.errors.full_messages.join(", ")
      redirect_back_or_default(spree.root_path)
      return
    else
      redirect_to potepan_cart_path
    end
  end

  # Shows the current incomplete order from the session
  def edit
    @order = Spree::Order.incomplete.find_or_initialize_by(
      guest_token: cookies.signed[:guest_token]
    )
  end

  def update
    if @order.contents.update_cart(order_params)
      if params.key?(:checkout) && @order.cart?
        @order.next
      elsif params.key?(:checkout)
        redirect_to potepan_checkout_state_path(@order.checkout_steps.first) && return
      end
    end
    redirect_to potepan_cart_path
  end

  private

  def store_guest_token
    cookies.permanent.signed[:guest_token] = params[:token] if params[:token]
  end

  def order_params
    if params[:order]
      params[:order].permit(*permitted_order_attributes)
    else
      {}
    end
  end

  def assign_order
    @order = current_order
    unless @order
      flash[:error] = t('spree.order_not_found')
      redirect_to(root_path) && return
    end
  end
end

class StaticPagesController < ApplicationController
  before_action :search_products

  def home
  end

  def help
  end

  def about
  end

  def contact
  end

  private

  def search_products
    @q = Product.ransack(params[:q])
    @products = @q.result(distinct: true).paginate(page: params[:page], per_page: 6)
      .order("products.created_at DESC").limit(12).offset(0)
    @url = products_path
  end
end

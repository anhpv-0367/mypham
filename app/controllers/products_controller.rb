class ProductsController < ApplicationController
  before_action :product_find_params, only: [:show]
  def index
    @q = Product.ransack(params[:q])
    @products = @q.result(distinct: true).paginate(page: params[:page], per_page: 6)
    @select = params[:q][:category_cont] if params[:q].present?
    @url = products_path
    if params[:category].present?
      @products = @products.where(category: params[:category])
    end
    @category = @products.first.category if params[:category].present? && @products.exists?
    @product_count = @products.count
    render "index"
  end

  def show
    @q = Product.ransack(params[:q])
    @products = @q.result(distinct: true).paginate(page: params[:page], per_page: 6)
    @select = params[:q][:category_cont] if params[:q].present?
    @url = products_path
  end

  private

  def product_find_params
    @product = Product.find(params[:id])
  end
end

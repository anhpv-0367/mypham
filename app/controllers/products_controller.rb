class ProductsController < ApplicationController
  before_action :product_find_params, only: [:show]
  def index
    @q = Product.ransack(params[:q])
    @products = @q.result(distinct: true).paginate(page: params[:page])
    @select = params[:q][:category_cont] if params[:q].present?
    render "index"
  end

  def show
  end

  private

  def product_find_params
    @product = Product.find(params[:id])
  end
end

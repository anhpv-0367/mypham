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
    @products = @q.result(distinct: true)
    if params[:category].present?
      @products = Product.where(category: params[:category])
    end
  end
end

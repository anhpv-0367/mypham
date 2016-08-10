class ProductsController < ApplicationController
  before_action :product_find_params, only: [:show]
  before_action :search_products, only: [:index, :show]

  def index
    @products = get_products(@products) if params[:category].present?
    @product_count = @products.count
    render "index"
  end

  def show
  end

  private

  def product_find_params
    id = params[:id].split("-")[0]
    @product = Product.find(id)
  end

  def get_products(products)
    if params[:category] == "my-pham-lam-sach"
      products = products.where("category = ? or category = ? or category = ? or category = ?", "tay-da-chet", "sua-rua-mat", "dau-goi", "mat-na" )
    elsif params[:category] == "my-pham-trang-diem"
      products = products.where("category = ? or category = ? or category = ? or category = ?", "phan-bb-lot-nen", "phan-phu-nuoc", "son-moi-duong", "trang-diem-mat" )
    elsif params[:category] == "my-pham-duong-da"
      products = products.where("category = ? or category = ? or category = ? or category = ? or category = ?", "kit-duong-da", "nuoc-hoa-hong", "xit-khoang", "sua-duong", "kem-chong-nang" )
    elsif params[:category] == "my-pham-dac-tri"
      products = products.where("category = ? or category = ?", "tri-nam-tan-nhang", "tri-mun")
    elsif params[:category] == "duong-the"
      products = products.where("category = ? or category = ? or category = ?", "tam-trang", "kem-duong", "sua-tam")
    elsif params[:category] == "nuoc-hoa"
      products = products.where("category = ? or category = ?", "nuoc-hoa-nam", "nuoc-hoa-nu")
    else
      products = products.where("category = ?", params[:category])
    end
    return products
  end

  def search_products
    @q = Product.ransack(params[:q])
    @products = @q.result(distinct: true).paginate(page: params[:page], per_page: 6)
    @select = params[:q][:category_cont] if params[:q].present?
    @url = products_path
  end
end

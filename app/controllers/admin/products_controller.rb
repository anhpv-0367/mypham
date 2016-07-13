class Admin::ProductsController < ApplicationController
  before_action :check_admin?
  before_action :product_find_params, only: [:show, :edit, :update, :destroy]
  before_action :search_products, only: [:index, :show]

  def index
    @products = get_products(@products) if params[:category].present?
    @product_count = @products.count
    render "index"
  end

  def show
  end

  def new
    @product = Product.new
    @selected = 0
  end

  def create
    @product = Product.new(product_params)
    if params[:product][:avatar].present?
      image = params[:product][:avatar]
      @uploader = ImageUploader.new(@product, image)
      @uploader.store!(File.open(image.path))
    end
    if @product.save
      flash[:success] = "success!"
      redirect_to admin_products_path
    else
      render 'new'
    end
  end

  def edit
    @selected = @product.read_attribute(:category)
  end

  def update
    if @product.update_attributes(product_params)
      flash[:success] = "Product updated"
      redirect_to admin_products_path
    else
      render 'edit'
    end
  end

  def destroy
    @product.destroy
    redirect_to admin_products_path
  end

  def dashboard
  end

  private

  def product_params
    params.require(:product).permit(:name, :category, :pre_price, :price, :avatar, :description)
  end

  def product_find_params
    @product = Product.find(params[:id])
  end

  def check_admin?
    redirect_to root_path if current_user.blank? || !current_user.admin?
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
    @url = admin_products_path
  end
end

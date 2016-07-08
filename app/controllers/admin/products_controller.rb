class Admin::ProductsController < ApplicationController
  before_action :check_admin?
  before_action :product_find_params, only: [:show, :edit, :update, :destroy]
  def index
    @q = Product.ransack(params[:q])
    @products = @q.result(distinct: true).paginate(page: params[:page], per_page: 6)
    @select = params[:q][:category_cont] if params[:q].present?
    if params[:category].present?
      @products = @products.where(category: params[:category])
    end
    @product_count = @products.count
    @url = admin_products_path
    render "index"
  end

  def show
    @q = Product.ransack(params[:q])
    @products = @q.result(distinct: true).paginate(page: params[:page], per_page: 6)
    @select = params[:q][:category_cont] if params[:q].present?
    @url = admin_products_path
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
    params[:product][:category] = params[:product][:category].to_i if params[:product][:category].present?
    params.require(:product).permit(:name, :category, :pre_price, :price, :avatar, :description)
  end

  def product_find_params
    @product = Product.find(params[:id])
  end

  def check_admin?
    redirect_to root_path if current_user.blank? || !current_user.admin?
  end
end

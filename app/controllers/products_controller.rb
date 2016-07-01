class ProductsController < ApplicationController
  before_action :check_admin?, only: [:update]
  before_action :product_find_params, only: [:show, :edit, :update, :destroy]
  def index
    # @products = Product.order(created_at: :desc).paginate(page: params[:page]) if current_user.admin?
    if current_user.admin?
      # params[:q][:category_cont] = params[:q][:category_cont].to_i if params[:q][:category_cont].present?
      @q = Product.ransack(params[:q])
      @products = @q.result(distinct: true)
    else
      redirect_to root_path
    end
  end

  def show
  end

  def new
    @product = Product.new
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
      redirect_to products_path
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @product.update_attributes(product_params)
      flash[:success] = "Product updated"
      redirect_to @product
    else
      render 'edit'
    end
  end

  def destroy
    @product.destroy
    redirect_to products_path
  end

  private

  def product_params
    params.require(:product).permit(:name, :category, :pre_price, :price, :avatar, :description)
  end

  def product_find_params
    @product = Product.find(params[:id])
  end

  def check_admin?
    redirect_to(root_url) unless current_user.admin?
  end
end

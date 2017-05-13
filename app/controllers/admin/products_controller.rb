class Admin::ProductsController < ApplicationController
  # 使用者必須登入
  before_action :authenticate_user!
  # 使用者必須是 admin 身份
  before_action :admin_required
  # 後台頁面排版
  layout "admin"

  def index
    @products = Product.all
  end

  def show
    @product = Product.find(params[:id])
  end

  def new
    @product = Product.new

    # 產品所屬的品牌/分類
    @brands = Brand.all.map { |b| [b.name, b.id] }
    @categories = Category.all.map { |c| [c.name, c.id] }

  end

  def create
    @product = Product.new(product_params)

    # 產品所屬的品牌/分類
    @product.brand_id = params[:brand_id]
    @product.category_id = params[:category_id]

    if @product.save
      redirect_to admin_products_path
    else
      render :new
    end
  end

  def edit
    @product = Product.find(params[:id])

    # 產品所屬的品牌/分類
    @brands = Brand.all.map { |b| [b.name, b.id] }
    @categories = Category.all.map { |c| [c.name, c.id] }
  end

  def update
    @product = Product.find(params[:id])

    # 產品所屬的品牌/分類
    @product.brand_id = params[:brand_id]
    @product.category_id = params[:category_id]

    if @product.update(product_params)
      redirect_to admin_products_path
    else
      render :edit
    end
  end

  # 發佈
  def publish
    @product = Product.find(params[:id])
    @product.publish!
    redirect_to :back
  end

  # 隱藏
  def hide
    @product = Product.find(params[:id])
    @product.hide!
    redirect_to :back
  end

  private

  def product_params
    params.require(:product).permit(:name, :description, :price, :quantity, :category_id, :brand_id, :is_hidden)
  end

end
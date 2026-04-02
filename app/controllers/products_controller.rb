class ProductsController < ApplicationController
  def index
    # variable
    @products = Product.all()
    @categories = Category.all()
    @brands = Product.distinct.pluck(:brand).compact



    if params[:query].present?
      q = "%#{params[:query].downcase}%"
      @products = @products.where(
        "LOWER(name) LIKE ? OR LOWER(description) LIKE ?",
        q, q
      )
    end


    if params[:category_ids].present?
      @products = @products.where(category_id: params[:category_ids])
    end

    if params[:brands].present?
      @products = @products.where(brand: params[:brands])
    end

    if params[:price_range].present?
      case params[:price_range]
      when "under_30"
        @products = @products.where("price < 30")
      when "30_to_60"
        @products = @products.where("price >= 30 AND price <= 60")
      when "60_to_100"
        @products = @products.where("price >= 60 AND price <= 100")
      when "100_to_150"
        @products = @products.where("price >= 100 AND price <= 150")
      when "150_to_200"
        @products = @products.where("price >= 150 AND price <= 200")
      when "200_to_300"
        @products = @products.where("price >= 200 AND price <= 300")
      when "over_300"
        @products = @products.where("price > 300")
      end
    end


    @products = @products.page(params[:page]).per(12)

  end

  def show
    @product = Product.find(params[:id])
  end
end

class PagesController < ApplicationController
  def home
    @products = Product.limit(8)
  end

  def login_signup
  end
end

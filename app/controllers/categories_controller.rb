class CategoriesController < ApplicationController

  before_filter :login_required

  # GET /categories
  def index
    @categories = Category.all
  end

  # GET /categories/1
  def show
    @category = Category.find(params[:id])
  end

  def new
    @category = Category.new
    @category.organization_id = session[:user][:organization_id]
  end

  # GET /categories/1/edit
  def edit
    @category = Category.find(params[:id])
  end

  # POST /categories
  def create
    @category = Category.new(params[:category])

    if @category.save
      redirect_to(edit_category_path(@category), :notice => 'Category was successfully created.')
    end
  end

  # PUT /categories/1
  def update
    @category = Category.find(params[:id])

    if @category.update_attributes(params[:category])
      redirect_to(edit_category_path(@category), :notice => 'Category was successfully updated.')
    end
  end

  # DELETE /categories/1
  def destroy
    @category = Category.find(params[:id])
    if @category.destroy
      redirect_to(categories_url, :notice => 'Category was successfully deleted.')
    end
  end

end

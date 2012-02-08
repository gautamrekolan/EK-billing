class CategoriesController < ApplicationController

  before_filter :login_required
  before_filter :manager_required

  def index
    @categories = Category.find_all_by_organization_id(session[:user][:organization_id],
                                                       :order => "category ASC, name ASC")
  end

  # GET /categories/new
  def new
    @category = Category.new
    @category.organization_id = session[:user][:organization_id]
    @types = [ "Farm Expenses", "Show Expenses", "Other Expenses" ]
  end

  def show
    @category = Category.find(params[:id])
  end

  # GET /categories/1/edit
  def edit
    @category = Category.find(params[:id])
    @types = [ "Farm Expenses", "Show Expenses", "Other Expenses" ]
  end

  # POST /payments
  def create
    @category = Category.new(params[:category])

    if @category.save
      redirect_to(@category, :notice => 'Category was successfully created.')
    else
      format.html { render :action => "new" }
    end
  end

  # PUT /categories/1
  def update
    @category = Category.find(params[:id])

    if @category.update_attributes(params[:category])
      redirect_to(@category, :notice => 'Category was successfully updated.')
    else
      render :action => "edit"
    end
  end

  # DELETE /categories/1
  def destroy
    @category = Category.find(params[:id])
    if @category.destroy
      redirect_to(categories_url)
    end
  end

end

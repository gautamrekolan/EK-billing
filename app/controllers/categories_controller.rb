class CategoriesController < ApplicationController

  before_filter :login_required

  def index
    @categories = Category.all(:order => "category ASC, name ASC  ")
  end

  # GET /categories/new
  # GET /categories/new.xml
  def new
    @category = Category.new
    @category.organization_id = session[:user][:organization_id]
    @types = [ "Farm Expenses", "Show Expenses", "Other Expenses" ]

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @payment }
    end
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
  # POST /payments.xml
  def create
    @category = Category.new(params[:category])

    respond_to do |format|
      if @category.save
        format.html { redirect_to(@category, :notice => 'Category was successfully created.') }
        format.xml  { render :xml => @category, :status => :created, :location => @category }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /categories/1
  # PUT /categories/1.xml
  def update
    @category = Category.find(params[:id])

    respond_to do |format|
      if @category.update_attributes(params[:category])
        format.html { redirect_to(@category, :notice => 'Category was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.xml
  def destroy
    @category = Category.find(params[:id])
    @category.destroy

    respond_to do |format|
      format.html { redirect_to(categories_url) }
      format.xml  { head :ok }
    end
  end
end

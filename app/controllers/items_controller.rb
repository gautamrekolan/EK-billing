class ItemsController < ApplicationController

  before_filter :login_required

  # GET /items
  def index
    @items = Item.all
  end

  # GET /items/1
  def show
    @item = Item.find(params[:id])
  end

  # GET /items/new
  def new
    @item = Item.new
    @item.category_id = params[:category]
    @item.invoice_id = params[:invoice]
    @item.customer_id = params[:customer]
    @item.horse_id = params[:horse]

    if @item.category_id.nil? == false
      @category = Category.find_by_id(params[:category])
      if @category.nil? == false
        @base_amount = @category.amount
        @item.amount = @category.amount
      end
    end

    @item.quantity = "1"

    if @item.invoice_id.nil? == false && @item.customer_id.nil?
      @customer_id = @item.invoice.customer_id
      @item.customer_id = @customer_id
    end

  end

  def popup
    @categories = Category.all
    render :layout => nil
  end

  # GET /items/1/edit
  def edit
    @item = Item.find(params[:id])
  end

  # POST /items
  def create
    @item = Item.new(params[:item])
    if @item.save
        @invoice = @item.invoice
        new_amount = @invoice.amount + @item.amount
        @invoice.update_attribute("amount", new_amount)
        redirect_to(invoice_path(@invoice), :notice => 'Item was successfully created.')
    else
        render :action => "new"
    end
  end

  # PUT /items/1
  def update
    @item = Item.find(params[:id])
    if @item.update_attributes(params[:item])
      @invoice = @item.invoice
      items = Item.find_all_by_invoice_id(@invoice.id)
      amount = 0
      items.each do |item|
        amount = amount + item.amount
      end
      @invoice.update_attribute("amount", amount)
      redirect_to(invoice_path(@invoice), :notice => 'Item was successfully updated.')
    else
      render :action => "edit"
    end
  end

  # DELETE /items/1
  def destroy
    @item = Item.find(params[:id])
    @invoice = @item.invoice
    if @item.destroy
      items = Item.find_all_by_invoice_id(@invoice.id)
      amount = 0
      items.each do |item|
        amount = amount + item.amount
      end
      @invoice.update_attribute("amount", amount)
    end
    redirect_to(invoice_path(@invoice), :notice => 'Item was successfully removed.')
  end
end

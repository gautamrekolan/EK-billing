class ItemsController < ApplicationController

  before_filter :login_required
  before_filter :manager_required

  # GET /items/1
  def show
    @item = Item.find(params[:id])
  end

  # GET /items/new
  def new
    @item = Item.new
    if params[:category].nil? == false && params[:customer].nil? == false
      @item.customer_id = params[:customer]
      @item.category_id = params[:category]
      @item.organization_id = session[:user][:organization_id]

      customer = Customer.find(@item.customer)
      if customer.invoices.empty? == false
        @horses = Horse.find_all_by_customer_id(customer)
        invoice = customer.invoices.last
        if invoice.status_code < 8
          @item.invoice_id = invoice.id
        else
          redirect_to(builder_path, :notice => "That customer does not currently have any open invoices.")
        end
      else
        redirect_to(builder_path, :notice => "That customer does not currently have any open invoices.")
      end
    else
      @invoice = Invoice.find(params[:invoice])
      @item.invoice_id = @invoice.id
      @item.customer_id = @invoice.customer.id
      @item.organization_id = @invoice.organization_id
      @horses = Horse.find_all_by_customer_id(customer)
    end
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
      redirect_to(@invoice, :notice => 'Item was successfully created.')
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
      redirect_to(@invoice, :notice => 'Item was successfully updated.')
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

    redirect_to(@invoice, :notice => 'Item was successfully deleted.')
  end

end

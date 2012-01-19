class PaymentsController < ApplicationController

  before_filter :login_required

  # GET /payments/new
  # GET /payments/new.xml
  def new
    @payment = Payment.new
    @invoice = Invoice.find(params[:invoice])
    @payment.invoice = @invoice
    # @invoice_display = @invoice.name
    @customer = Customer.find(@invoice.customer_id)
    @payment.customer = @customer
    # @customer_display = @customer.first_name + " " + @customer.last_name

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @payment }
    end
  end

  # GET /payments/1/edit
  def edit
    @payment = Payment.find(params[:id])
  end

  # POST /payments
  # POST /payments.xml
  def create
    @payment = Payment.new(params[:payment])

    respond_to do |format|
      if @payment.save
        # TODO: Calculate remaining invoice balance and mark "Partially Paid" or "Paid" if necessary
        @invoice = @payment.invoice
        payment_total = 0
        payments = Payment.find_all_by_invoice_id(@invoice.id).to_a
        payments.each do |payment|
          payment_total += payment.payment_amount
        end

        remaining_balance = @invoice.amount - payment_total
        @invoice.update_attribute("amount", remaining_balance)
        if remaining_balance > 0
          Invoice.update_status(@invoice.id, "Partially Paid")
        else
          Invoice.update_status(@invoice.id, "Paid")
        end
        format.html { redirect_to invoice_path(:id => @invoice, :notice => 'Payment was successfully created.') }
        format.xml  { render :xml => @invoice, :status => :created, :location => @invoice }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @payment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /payments/1
  # PUT /payments/1.xml
  def update
    @payment = Payment.find(params[:id])
    @invoice = @payment.invoice

    respond_to do |format|
      if @payment.update_attributes(params[:payment])
        # TODO: Calculate remaining invoice balance and mark "Partially Paid" or "Paid" if necessary
        @invoice = @payment.invoice

        items_total = 0
        items = Item.find_all_by_invoice_id(@invoice.id).to_a
        items.each do |item|
          items_total += item.amount
        end
        payment_total = 0
        payments = Payment.find_all_by_invoice_id(@invoice.id).to_a
        payments.each do |payment|
          payment_total += payment.payment_amount
        end

        remaining_balance = items_total - payment_total
        @invoice.update_attribute("amount", remaining_balance)
        if remaining_balance > 0
          Invoice.update_status(@invoice.id, "Partially Paid")
        else
          Invoice.update_status(@invoice.id, "Paid")
        end
        format.html { redirect_to invoice_path(:id => @invoice, :notice => 'Payment was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @payment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /payments/1
  # DELETE /payments/1.xml
  def destroy
    @payment = Payment.find(params[:id])
    @invoice = @payment.invoice
    @payment.destroy

    # TODO: Calculate remaining invoice balance and mark "Partially Paid" or "Paid" if necessary
    @invoice = @payment.invoice
    payment_total = 0
    payments = Payment.find_all_by_invoice_id(@invoice.id).to_a
    payments.each do |payment|
      payment_total += payment.payment_amount
    end

    remaining_balance = @invoice.amount - payment_total
    @invoice.update_attribute("amount", remaining_balance)
    if remaining_balance > 0
      Invoice.update_status(@invoice.id, "Partially Paid")
    else
      Invoice.update_status(@invoice.id, "Paid")
    end

    respond_to do |format|
      format.html { redirect_to invoice_path(:id => @invoice, :notice => 'Payment was successfully removed.') }
      format.xml  { head :ok }
    end
  end
end

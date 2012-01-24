class PaymentsController < ApplicationController

  before_filter :login_required

  # GET /payments/1
  def show
    @payment = Payment.find(params[:id])
  end

  # GET /payments/new
  def new
    @payment = Payment.new
    @payment.invoice_id = params[:invoice]
    @payment_types = [ "Cash", "Check", "Credit card", "Money order", "Other" ]
  end

  # GET /payments/1/edit
  def edit
    @payment = Payment.find(params[:id])
    @payment_types = [ "Cash", "Check", "Credit card", "Money order", "Other" ]
  end

  # POST /payments
  def create
    @payment = Payment.new(params[:payment])

    if @payment.save
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

      redirect_to(edit_payment_path(@payment.invoice), :notice => 'Payment was successfully created.')
    else
      @payment_types = [ "Cash", "Check", "Credit card", "Money order", "Other" ]
      render :action => "new"
    end
  end

  # PUT /payments/1
  def update
    @payment = Payment.find(params[:id])

    if @payment.update_attributes(params[:payment])
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

      redirect_to(@payment.invoice, :notice => 'Payment was successfully updated.')
    else
      @payment_types = [ "Cash", "Check", "Credit card", "Money order", "Other" ]
      render :action => "edit"
    end
  end

  # DELETE /payments/1
  def destroy
    @payment = Payment.find(params[:id])
    if @payment.destroy
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

      redirect_to(@invoice, :notice => 'Payment was successfully deleted.')
    end
  end

end

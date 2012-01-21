class PaymentsController < ApplicationController
  # GET /payments
  # GET /payments.xml
  def index
    @payments = Payment.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @payments }
    end
  end

  # GET /payments/1
  # GET /payments/1.xml
  def show
    @payment = Payment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @payment }
    end
  end

  # GET /payments/new
  # GET /payments/new.xml
  def new
    @payment = Payment.new
    @payment.invoice_id = params[:invoice]
    @payment_types = [ "Cash", "Check", "Credit card", "Money order", "Other" ]

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @payment }
    end
  end

  # GET /payments/1/edit
  def edit
    @payment = Payment.find(params[:id])
    @payment_types = [ "Cash", "Check", "Credit card", "Money order", "Other" ]
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

        format.html { redirect_to(edit_payment_path(@payment), :notice => 'Payment was successfully created.') }
        format.xml  { render :xml => @payment, :status => :created, :location => @payment }
      else
        @payment_types = [ "Cash", "Check", "Credit card", "Money order", "Other" ]
        format.html { render :action => "new" }
        format.xml  { render :xml => @payment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /payments/1
  # PUT /payments/1.xml
  def update
    @payment = Payment.find(params[:id])

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

        format.html { redirect_to(edit_payment_path(@payment), :notice => 'Payment was successfully updated.') }
        format.xml  { head :ok }
      else
        @payment_types = [ "Cash", "Check", "Credit card", "Money order", "Other" ]
        format.html { render :action => "edit" }
        format.xml  { render :xml => @payment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /payments/1
  # DELETE /payments/1.xml
  def destroy
    @payment = Payment.find(params[:id])
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
      format.html { redirect_to(@invoice) }
      format.xml  { head :ok }
    end
  end
end

class PaymentsController < ApplicationController

  require 'active_merchant'
  require 'bigdecimal'

  before_filter :login_required
  before_filter :manager_required, :except => [ :creditcard, :relay_response, :error, :receipt, :authorize ]

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

  def creditcard
    @invoice = Invoice.find(params[:id])
    @months = [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ]
    @years = [ 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020 ]
  end

  def authorize
    @invoice = Invoice.find(params['id'])

    amount_to_charge = 300
    ActiveMerchant::Billing::Base.mode = :test
    creditcard = ActiveMerchant::Billing::CreditCard.new(
      :number => params['payment']['card_num'],
      :verification_value => params['payment']['card_code'],
      :month => params['payment']['month'],
      :year => params['payment']['year'],
      :first_name => params['payment']['first_name'],
      :last_name => params['payment']['last_name'],
      :type => 'VISA'
    )

    gateway = ActiveMerchant::Billing::AuthorizeNetGateway.new(
      :login => AUTHORIZE_NET_CONFIG['api_login_id'],
      :password => AUTHORIZE_NET_CONFIG['api_transaction_key'],
      :test => 'true'
    )

    response = gateway.authorize(amount_to_charge*100 , creditcard ,
      :billing_address => {
          :name => params['payment']['first_name'] + " " + params['payment']['last_name'],
          :address1 => params['payment']['address'],
          :city => params['payment']['city'],
          :state => params['payment']['state'],
          :country => 'US',
          :zip => params['payment']['zip']
      }
    )

    if response.success?
      gateway.capture(amount_to_charge, response.authorization)
      @payment = Payment.new
      @payment.date = Date.today
      @payment.payment_type = 'Credit card'
      @payment.amount = amount_to_charge
      @payment.invoice_id = @invoice.id
      @payment.transaction_id = response.params['transaction_id']
      if @payment.save
        new_amount = @invoice.amount - amount_to_charge
        @invoice.update_attribute("amount", new_amount)
      end
      redirect_to(payment_receipt_path(@payment.id))
    else
      render :text => 'Fail: ' + response.message.to_s and return
    end
  end

  def receipt
    @payment = Payment.find(params[:id])
    @invoice = @payment.invoice

    respond_to do |format|
      format.html # show.html.erb
      format.pdf {
        render :layout => false
      }
    end
  end



end

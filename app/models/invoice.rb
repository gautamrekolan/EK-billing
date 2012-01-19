require 'digest'

class Invoice < ActiveRecord::Base
  belongs_to :customer
  belongs_to :horse
  has_many :items,    :order => "category_id asc, description asc"
  has_many :payments, :order => "date_received asc"
  has_many :statuses, :order => "status_code asc"

  validates :name,        :presence => true, :length => { :maximum => 250 }
  validates :start_date,  :presence => true
  validates :end_date,    :presence => true
  validates :issued_date, :presence => true
  validates :due_date,    :presence => true
  # TO-DO: Validate currency
  validates :amount,      :presence => true, :format => { :with => /^[0-9]*(\.[0-9]{1,2})?$|^[0-9]{1,3}(,[0-9]{3})*(\.[0-9]{1,2})?$/ }
  validates :customer_id, :presence => true

  def Invoice.update_status(invoice_id, status)
    @invoice = Invoice.find(invoice_id)
    @status = Status.new
    @status.invoice_id = invoice_id
    @status.status = status
    status_code = 0
    if status == "Opened"
      status_code = 1
    elsif status == "Emailed" || status == "Mailed"
      status_code = 2
    elsif status == "Confirmed"
      status_code = 3
    elsif status == "Mail Requested"
      status_code = 4
    elsif status == "Mailed (Secondary)"
      status_code = 5
    elsif status == "Partially Paid"
      status_code = 6
    elsif status == "Reminded"
      status_code = 7
    elsif status == "Paid"
      status_code = 8
    end
    @status.status_code = status_code
    @status.created_at = Date.today.strftime("%Y-%m-%d %H:%M:%S")
    @status.updated_at = Date.today.strftime("%Y-%m-%d %H:%M:%S")
    if @status.save
      @invoice.update_attribute("status_code", status_code)
      @invoice.update_attribute("status", status)
      true
    else
      false
    end
  end

end

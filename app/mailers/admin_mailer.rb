class AdminMailer < ActionMailer::Base
  default :from => "lowerhopewellfarm@gmail.com"

  def test_email
    mail(:to => "elysedougherty@gmail.com", :subject => "Testing")
  end

  def invoice_issued(invoice)
    # @invoice = invoice
    # @invoice_id = encrypt_invoice(@invoice.id.to_s)
    attachments[invoice.name + "-" + invoice.customer.last_name + ".pdf"] = File.read("#{Rails.root}/public/files/pdfs/issued/" + invoice.id.to_s + ".pdf")
    @invoice = Invoice.find(invoice.id)
    mail(:to => "elysedougherty@gmail.com", :subject => "New Lower Hopewell Invoice")
    # mail(:to => @invoice.customer.email, :subject => "New Lower Hopewell Invoice")
    # log sending of email
    f = File.new("#{Rails.root}/log/emails.txt", 'a')
    f.puts Time.now.strftime("%m/%d/%Y %l:%M %p") + " - Emailed " + invoice.name + " to " + invoice.customer.first_name + " " + invoice.customer.last_name + " at " + invoice.customer.email + "; copied elysedougherty@gmail.com."
  end

  def invoice_reminder(invoice)
    @invoice = invoice
    @invoice_id = encrypt_invoice(@invoice.id.to_s)
    attachments[@invoice.name + "-" + @invoice.customer.last_name + ".pdf"] = File.read("#{Rails.root}/public/files/pdfs/issued/" + @invoice.id.to_s + ".pdf")
    mail(:to => "elysedougherty@gmail.com", :subject => "Lower Hopewell Invoice Reminder")
    # mail(:to => @invoice.customer.email, :subject => "Lower Hopewell Invoice Reminder")
  end

  def invoice_pastdue(invoice)
    @invoice = invoice
    attachments[@invoice.name + "-" + @invoice.customer.last_name + ".pdf"] = File.read("#{Rails.root}/public/files/pdfs/issued/" + @invoice.id.to_s + ".pdf")
    mail(:to => "elysedougherty@gmail.com", :subject => "Lower Hopewell Invoice Reminder")
    # mail(:to => @invoice.customer.email, :subject => "Lower Hopewell Invoice Reminder")
  end

  def invoice_mailed(invoice)
    @invoice = invoice
    attachments[@invoice.name + "-" + @invoice.customer.last_name + ".pdf"] = File.read("#{Rails.root}/public/files/pdfs/issued/" + @invoice.id.to_s + ".pdf")
    mail(:to => "elysedougherty@gmail.com", :subject => "Lower Hopewell Invoice Mailed")
    # mail(:to => @invoice.customer.email, :subject => "Lower Hopewell Invoice Mailed")
  end

  def invoice_paid(invoice)
    @invoice = invoice
    @status = Status.find_by_invoice_id(@invoice.id, :order => "status_code desc", :limit => 1)
    attachments[@invoice.name + "-" + @invoice.customer.last_name + ".pdf"] = File.read("#{Rails.root}/public/files/pdfs/issued/" + @invoice.id.to_s + ".pdf")
    mail(:to => "elysedougherty@gmail.com", :subject => "Lower Hopewell Payment Received")
    # mail(:to => @invoice.customer.email, :subject => "Lower Hopewell Payment Received")
  end

  private

    def encrypt_invoice(string)
      cipher = Gibberish::AES.new("snoopyandlowerhopewellfarm")
      return cipher.enc(string)
    end

end

#logopath = "#{Rails.root}/public/images/logo.jpg"
#pdf.image logopath, :width => 134, :height => 90, :position => :center

pdf.move_down 30

pdf.font_size = 10
pdf.text "Please make checks payable to:", :style => :bold
if @invoice.organization.custom.nil? == false
  if @invoice.organization.custom.checks_payable_to.blank? == false
    pdf.text @invoice.organization.custom.checks_payable_to
  else
    pdf.text @invoice.organization.name + " or " + @invoice.organization.contact
  end
else
  pdf.text @invoice.organization.name + " or " + @invoice.organization.contact
end
pdf.text @invoice.organization.address
pdf.text @invoice.organization.city + ", " + @invoice.organization.state + " " + @invoice.organization.zip
pdf.text number_to_phone(@invoice.organization.phone)
pdf.text @invoice.organization.email

pdf.move_down 20
pdf.text @invoice.name, :size => 12, :style => :bold
pdf.font_size = 10
pdf.text "Start Date: " + @invoice.start_date.strftime("%B %e, %Y")
pdf.text "End Date: " + @invoice.end_date.strftime("%B %e, %Y")
pdf.text "Due Date: " + @invoice.due_date.strftime("%B %e, %Y")

if @invoice.notes.blank? == false
  pdf.move_down 20
  pdf.text "**NOTE: " + @invoice.notes
end

pdf.move_down 20
pdf.text "Invoice Items", :size => 12, :style => :bold
pdf.font_size = 10

if @invoice.items.empty? == false
  items = @invoice.items.map do |item|
   [
        item.category.name,
        item.description,
        item.quantity,
        number_to_currency(item.amount)
   ]
  end

  pdf.table items, :headers => [ 'Category', 'Description', 'Quantity', 'Total' ],
    :border_style => :grid, :font_size => 10, :column_widths => { 0 => 150, 1 => 225, 2 => 65, 3 => 100 },
    :align_headers => { 0 => :left, 1 => :left, 2 => :center, 3 => :center },
    :align => { 0 => :left, 1 => :left, 2 => :right, 3 => :right }
else
  pdf.text "There are no items on this invoice."
end

pdf.move_down 20
pdf.text "AMOUNT DUE: " + number_to_currency(@invoice.amount), :size => 14, :align => :right, :style => :bold

if @invoice.organization.custom.nil? == false
  if @invoice.organization.custom.customer_info_check == 1
    pdf.move_down 20
    pdf.text "Please contact " + @invoice.organization.contact + " if any of your information has changed:", :style => :bold
    pdf.text @invoice.customer.first_name + " " + @invoice.customer.last_name
    pdf.text @invoice.customer.address
    pdf.text @invoice.customer.city + ", " + @invoice.customer.state + " " + @invoice.customer.zip
    if @invoice.customer.cell.blank? == false
      pdf.text "Cell: " + number_to_phone(@invoice.customer.cell, :area_code => true)
    end
    if @invoice.customer.home.blank? == false
      pdf.text "Home: " + number_to_phone(@invoice.customer.home, :area_code => true)
    end
    if @invoice.customer.work.blank? == false
      pdf.text "Work: " + number_to_phone(@invoice.customer.work, :area_code => true)
    end
    pdf.text @invoice.customer.email
  end
else
  pdf.move_down 20
    pdf.text "Please contact " + @invoice.organization.contact + " if any of your information has changed:", :style => :bold
    pdf.text @invoice.customer.first_name + " " + @invoice.customer.last_name
    pdf.text @invoice.customer.address
    pdf.text @invoice.customer.city + ", " + @invoice.customer.state + " " + @invoice.customer.zip
    if @invoice.customer.cell.blank? == false
      pdf.text "Cell: " + number_to_phone(@invoice.customer.cell, :area_code => true)
    end
    if @invoice.customer.home.blank? == false
      pdf.text "Home: " + number_to_phone(@invoice.customer.home, :area_code => true)
    end
    if @invoice.customer.work.blank? == false
      pdf.text "Work: " + number_to_phone(@invoice.customer.work, :area_code => true)
    end
    pdf.text @invoice.customer.email
end

pdf.move_down 30
if @invoice.organization.custom.nil? == false
  if @invoice.organization.custom.signoff_line.blank? == false
    pdf.text @invoice.organization.custom.signoff_line, :size => 12, :style => :bold, :align => :right
  else
    pdf.text "Thank you for your prompt payment and continued business!", :size => 12, :style => :bold, :align => :right
  end
else
  pdf.text "Thank you for your prompt payment and continued business!", :size => 12, :style => :bold, :align => :right
end
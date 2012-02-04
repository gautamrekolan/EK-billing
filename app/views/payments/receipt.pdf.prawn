#logopath = "#{Rails.root}/public/images/logo.jpg"
#pdf.image logopath, :width => 134, :height => 90, :position => :center

pdf.move_down 30

pdf.font_size = 20
pdf.text "Thank you for your payment!"

pdf.move_down 20

pdf.font_size = 12
pdf.text "Payment Amount :" + number_to_currency(@payment.amount)
pdf.text "Payment Date: " + @payment.date.strftime("%B %e, %Y")
pdf.text "Transaction ID: " + @payment.transaction_id.to_s

pdf.move_down 30

pdf.text @invoice.name, :size => 12, :style => :bold
pdf.font_size = 10
pdf.text "Start Date: " + @invoice.start_date.strftime("%B %e, %Y")
pdf.text "End Date: " + @invoice.end_date.strftime("%B %e, %Y")
pdf.text "Due Date: " + @invoice.due_date.strftime("%B %e, %Y")

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
logopath = "#{Rails.root}/public/images/lhflogo.jpg"
pdf.image logopath, :width => 134, :height => 90, :position => :center

pdf.move_down 30
pdf.font "Helvetica"

pdf.font_size = 10
pdf.text "Please make checks payable to:", :style => :bold
pdf.text "Alida Burkholder or Lower Hopewell Farm"
pdf.text "395 Speedwell Forge Road"
pdf.text "Lititz, PA 17543"
pdf.text "(717) 587-7421"
pdf.text "lhfapps@ptd.net"

pdf.move_down 20
pdf.text @invoice.name, :size => 12, :style => :bold
pdf.font_size = 10
pdf.text "Start Date: " + @invoice.start_date.to_s(:long)
pdf.text "End Date: " + @invoice.end_date.to_s(:long)
pdf.text "Due Date: " + @invoice.due_date.to_s(:long)

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
   pdf.text "This invoice has no items."
end

pdf.move_down 20
pdf.text "AMOUNT DUE: " + number_to_currency(@invoice.amount), :size => 14, :align => :right, :style => :bold

pdf.move_down 20
pdf.text "Please contact Alida if any of your information has changed:", :style => :bold
pdf.text @invoice.customer.first_name + " " + @invoice.customer.last_name
pdf.text @invoice.customer.address
pdf.text @invoice.customer.city + ", " + @invoice.customer.state + " " + @invoice.customer.zip
pdf.text number_to_phone(@invoice.customer.phone)
pdf.text @invoice.customer.email

pdf.move_down 30
pdf.text "Thank you for your prompt payment and continued business!", :size => 12, :style => :bold, :align => :right
pdf.text "- Alida", :size => 12, :font => "Comic Sans MS", :align => :right
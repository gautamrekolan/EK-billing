include ActionView::Helpers::NumberHelper

class CustomsController < ApplicationController

  # GET /customs/1
  def sample
    @organization = Organization.find(session[:user][:organization_id])
    pdf = Prawn::Document.new()
    pdf = build_sample(pdf, @organization)
    pdf.render_file("#{Rails.root}/public/files/organizations/samples/" + @organization.id.to_s + ".pdf")
    @filename =     "#{Rails.root}/public/files/organizations/samples/" + @organization.id.to_s + ".pdf"
  end

  # GET /customs/new
  def new
    @custom = Custom.new
    @custom.organization_id = session[:user][:organization_id]
  end

  # GET /customs/1/edit
  def edit
    @custom = Custom.find(params[:id])
  end

  # POST /customs
  def create
    @custom = Custom.new(params[:custom])
    @image_data = params[:custom][:filename]
    @custom.logo_extension = @image_data.original_filename.split('.').last
    @custom.logo_filename = nil

    if @custom.save
      Custom.save_image(@custom.organization_id, @custom.logo_extension, @image_data)
      redirect_to(@custom, :notice => 'Customization was successfully updated.')
    else
      render :action => "new"
    end
  end

  # PUT /customs/1
  def update
    @custom = Custom.find(params[:id])

    if @custom.update_attributes(params[:custom])
      redirect_to(@custom, :notice => 'Customization was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def build_sample(pdf, organization)

    @organization = organization

    #logopath = "#{Rails.root}/public/images/logo.jpg"
    #pdf.image logopath, :width => 134, :height => 90, :position => :center

    pdf.move_down 30

    pdf.font_size = 10
    pdf.text "Please make checks payable to:", :style => :bold
    if @organization.custom.nil? == false
      if @organization.custom.checks_payable_to.blank? == false
        pdf.text @organization.custom.checks_payable_to
      else
        pdf.text @organization.name + " or " + @organization.contact
      end
    else
      pdf.text @organization.name + " or " + @organization.contact
    end
    pdf.text @organization.address
    pdf.text @organization.city + ", " + @organization.state + " " + @organization.zip
    pdf.text number_to_phone(@organization.phone, :area_code => true)
    pdf.text @organization.email

    pdf.move_down 20
    pdf.text "Invoice Name", :size => 12, :style => :bold
    pdf.font_size = 10
    pdf.text "Start Date: January 1, 2012"
    pdf.text "End Date: January 31, 2012"
    pdf.text "Due Date: January 10, 2012"

    pdf.move_down 20
    pdf.text "**NOTE: Optional notes."

    pdf.move_down 20
    pdf.text "Invoice Items", :size => 12, :style => :bold
    pdf.font_size = 10

    pdf.text "There are no items on this invoice."

    pdf.move_down 20
    pdf.text "AMOUNT DUE: $0.00", :size => 14, :align => :right, :style => :bold

    if @organization.custom.nil? == false
      if @organization.custom.customer_info_check == 1
        pdf.move_down 20
        pdf.text "Please contact " + @organization.contact + " if any of your information has changed:", :style => :bold
        pdf.text "Customer Name"
        pdf.text "Customer Address"
        pdf.text "City, State Zip"
        pdf.text "Customer Home Phone (if provided)"
        pdf.text "Customer Cell Phone (if provided)"
        pdf.text "Customer Work Phone (if provided)"
        pdf.text "Customer Email"
      end
    else
      pdf.move_down 20
        pdf.text "Please contact " + @organization.contact + " if any of your information has changed:", :style => :bold
        pdf.text "Customer Name"
        pdf.text "Customer Address"
        pdf.text "City, State Zip"
        pdf.text "Customer Home Phone (if provided)"
        pdf.text "Customer Cell Phone (if provided)"
        pdf.text "Customer Work Phone (if provided)"
        pdf.text "Customer Email"
    end

    pdf.move_down 30
    if @organization.custom.nil? == false
      if @organization.custom.signoff_line.blank? == false
        pdf.text @organization.custom.signoff_line
      else
        pdf.text "Thank you for your prompt payment and continued business!", :size => 12, :style => :bold, :align => :right
      end
    else
      pdf.text "Thank you for your prompt payment and continued business!", :size => 12, :style => :bold, :align => :right
    end
    return pdf
  end

end

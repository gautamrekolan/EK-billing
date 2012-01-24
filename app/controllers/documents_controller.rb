class DocumentsController < ApplicationController

  before_filter :login_required

  # GET /documents
  def index
    @documents = Document.all(:order => "customer_id asc, horse_id asc, description asc")
  end

  # GET /documents/1
  def show
    @document = Document.find(params[:id])
    @document.filename = "/files/documents/" + @document.id.to_s + "." + @document.extension
  end

  # GET /documents/new
  def new
    @document = Document.new
    @document.organization_id = session[:user][:organization_id]
    @document.customer_id = params[:customer]
    @document.horse_id = params[:horse]
  end

  # GET /documents/1/edit
  def edit
    @document = Document.find(params[:id])
  end

  # POST /documents
  def create
    @document = Document.new(params[:document])
    @image_data = params[:document][:filename]
    @document.extension = @image_data.original_filename.split('.').last
    @document.filename = nil

    if @document.save
      Document.save_image(@document.id, @document.extension, @image_data)
      redirect_to(@document, :notice => 'Document was successfully created.')
    else
      render :action => "new"
    end
  end

  # PUT /documents/1
  def update
    @document = Document.find(params[:id])

    if @document.update_attributes(params[:document])
      redirect_to(@document, :notice => 'Document was successfully updated.')
    else
      render :action => "edit"
    end
  end

  # DELETE /documents/1
  def destroy
    @document = Document.find(params[:id])
    @horse = nil
    @customer = nil
    if @document.horse.nil? == false
      @horse = @document.horse
    elsif @document.customer.nil? == false
      @customer = @document.customer
    end
    if @document.destroy
      if @horse.nil? == false
        redirect_to(@horse, :notice => 'Document was successfully deleted.')
      elsif @customer.nil? == false
        redirect_to(@customer, :notice => 'Document was successfully deleted.')
      else
        redirect_to(documents_path, :notice => 'Document was successfully deleted.')
      end
    end
  end

end

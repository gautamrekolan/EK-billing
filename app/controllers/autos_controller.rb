class AutosController < ApplicationController
  # GET /autos
  # GET /autos.xml
  def index
    @autos = Auto.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @autos }
    end
  end

  # GET /autos/1
  # GET /autos/1.xml
  def show
    @auto = Auto.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @auto }
    end
  end

  # GET /autos/new
  # GET /autos/new.xml
  def new
    @auto = Auto.new
    @auto.customer_id = params[:customer]

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @auto }
    end
  end

  # GET /autos/1/edit
  def edit
    @auto = Auto.find(params[:id])
  end

  # POST /autos
  # POST /autos.xml
  def create
    @auto = Auto.new(params[:auto])

    respond_to do |format|
      if @auto.save
        format.html { redirect_to(@auto, :notice => 'Auto was successfully created.') }
        format.xml  { render :xml => @auto, :status => :created, :location => @auto }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @auto.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /autos/1
  # PUT /autos/1.xml
  def update
    @auto = Auto.find(params[:id])

    respond_to do |format|
      if @auto.update_attributes(params[:auto])
        format.html { redirect_to(@auto, :notice => 'Auto was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @auto.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /autos/1
  # DELETE /autos/1.xml
  def destroy
    @auto = Auto.find(params[:id])
    @auto.destroy

    respond_to do |format|
      format.html { redirect_to(autos_url) }
      format.xml  { head :ok }
    end
  end
end

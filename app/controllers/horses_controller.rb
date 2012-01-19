class HorsesController < ApplicationController

  before_filter :login_required

  # GET /horses/1
  # GET /horses/1.xml
  def show
    @horse = Horse.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @horse }
    end
  end

  # GET /horses/new
  # GET /horses/new.xml
  def new
    @horse = Horse.new
    @horse.customer_id = params[:customer]

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @horse }
    end
  end

  # GET /horses/1/edit
  def edit
    @horse = Horse.find(params[:id])
  end

  # POST /horses
  # POST /horses.xml
  def create
    @horse = Horse.new(params[:horse])

    respond_to do |format|
      if @horse.save
        format.html { redirect_to(@horse, :notice => 'Horse was successfully created.') }
        format.xml  { render :xml => @horse, :status => :created, :location => @horse }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @horse.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /horses/1
  # PUT /horses/1.xml
  def update
    @horse = Horse.find(params[:id])

    respond_to do |format|
      if @horse.update_attributes(params[:horse])
        format.html { redirect_to(@horse, :notice => 'Horse was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @horse.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /horses/1
  # DELETE /horses/1.xml
  def destroy
    @horse = Horse.find(params[:id])
    if @horse.nil? == false
      @customer_id = @horse.customer_id
    end
    @horse.destroy

    respond_to do |format|
      format.html { redirect_to(customer_url(@customer_id)) }
      format.xml  { head :ok }
    end
  end
end

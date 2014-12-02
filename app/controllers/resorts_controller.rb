class ResortsController < ApplicationController
	after_action :access_control_headers
  before_filter :find_resort, :only => [:show, :edit, :update, :destroy]

  def index
  	if params["all"] == "true"
     @resorts = Resort.all.to_a
   else
     @resorts = Resort.near([params[:latitude], params[:longitude]], 100000000000000000000000)
   end
   respond_to do |wants|
      wants.html # index.html.erb
      wants.xml  { render :xml => @resorts }
      wants.json { render :json => @resorts}
    end
  end

  def show
    respond_to do |wants|
      wants.html # show.html.erb
      wants.xml  { render :xml => @resort }
      wants.json { render :json => @resort}
    end
  end

  def categories
    @categories = Resort.find(params[:id])
    respond_to do |wants|
      wants.html # show.html.erb
      wants.json { render :json => @categories.to_json(:include => { :categories => { :include => :items }})}
    end
  end

  def new
    @resort = Resort.new

    respond_to do |wants|
      wants.html # new.html.erb
      wants.xml  { render :xml => @resort }
      wants.json { render :json => @resort}
    end
  end

  def edit
  end

  def create
    @resort = Resort.new(secure_params)

    respond_to do |wants|
      if @resort.save
        flash[:notice] = 'Resort was successfully created.'
        wants.html { redirect_to(resorts_path) }
        wants.xml  { render :xml => @resort, :status => :created, :location => @resort }
      else
        wants.html { render :action => "new" }
        wants.xml  { render :xml => @resort.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |wants|
      if @resort.update_attributes(secure_params)
        flash[:notice] = 'Resort was successfully updated.'
        wants.html { redirect_to(resorts_path) }
        wants.xml  { head :ok }
      else
        wants.html { render :action => "edit" }
        wants.xml  { render :xml => @resort.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @resort.destroy

    respond_to do |wants|
      wants.html { redirect_to(resorts_path) }
      wants.xml  { head :ok }
    end
  end

  private
  def find_resort
    @resort = Resort.find(params[:id])
  end

  def secure_params
    params.require(:resort).permit(:name, :address)
  end

  def access_control_headers
   headers['Access-Control-Allow-Origin'] = "*"
   headers['Access-Control-Request-Method'] = %w{GET POST OPTIONS}.join(",")
 end

end

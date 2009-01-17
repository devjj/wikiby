class WikiController < ApplicationController
  
  def index
    logger.debug "-- wiki/index: active_path: #{active_path}"
    if active_path == '/'
      @active_page = Page.find_by_location('/home')
    else
      @active_page = Page.find_by_location(active_path)
    end
    
    # Render the page if it exists
    if @active_page
      render :action => 'show'
    else
      # The page does not exist.  Show the new page form.
      if active_path == '/'
        redirect_to '/home'
      else
        new
        render :action => 'new'
      end
    end
  end

  def new
    @page = Page.new
    @page.suggested_slug = current_path_component
    @page.title = current_path_component.humanize unless current_path_component.blank?
    @page.reference_location = active_path
    
    logger.debug "Preparing new @page: #{@page.inspect}"
  end

  def create
    @page = Page.new(params[:page])
    
    if @page.save
      unless @page.slug == 'home'
        redirect_to @page.location
      else
        redirect_to '/'
      end
      
    else
      render :action => 'new'
    end
  end

  def edit
    path = extract_path(params[:url])
    logger.debug "-- wiki/edit: #{path}"
    @page = Page.find_by_location(path)
    
    unless @page
      redirect_to path
    end
  end

  def update
    @page = Page.find_by_location(active_path)
    
    if @page
      if @page.update_attributes(params[:page])
        unless @page.slug == 'home'
          redirect_to @page.location
        else
          redirect_to homepage_path
        end
      else
        render :action => 'edit'
      end
    else
      redirect_to homepage_path
    end
  end

  def destroy
  end

end

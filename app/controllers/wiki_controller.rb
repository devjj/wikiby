class WikiController < ApplicationController
  
  def index
    logger.debug "-- wiki/index: active_path: #{active_path}"
    @active_page = Page.find_by_location(active_path)
    
    # Render the page if it exists
    if @active_page
      show
      render :action => 'show'
    else
      # The page does not exist.  Show the new page form.
      new
      render :action => 'new'
    end
  end

  def new
    @page = Page.new
  end

  def create
  end

  # def show
  # end

  def edit
  end

  def update
  end

  def destroy
  end

end

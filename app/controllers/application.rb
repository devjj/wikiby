# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class WikiError < StandardError; end

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '8167d62aa61d993011eb77195fcc9002'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  def active_path
    unless @active_path.blank?
      @active_path
    else
      unless params[:url].blank?
        @active_path = '/' + params[:url].to_a.join('/')
      else
        @active_path = '/'
      end
    end
  end
end

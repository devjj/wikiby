class Page < ActiveRecord::Base
  include URLComponents
  
  validates_presence_of :title, :body
  before_save :set_parent, :set_slug, :set_cached_body, :set_location
  attr_protected :slug, :cached_body
  
  attr_accessor :suggested_slug, :reference_location
  
  acts_as_tree
  
  def data
    unless self.cached_body.blank?
      cached_body
    else
      set_cached_body
      save!
      cached_body
    end
  end
  
  def link
    self.location[1...self.location.length]
  end
  
  private
  def extract_parent_path(url)
    logger.debug "!- extract_parent_path url: #{url.inspect}"
    case url
    when String
      path = url.split('/').compact
      path = path[0...(path.length - 1)]
      path.join('/')
    when Array
      url[0..(url.length - 1)].compact.join('/')
    else
      raise ArgumentError.new("String or Array expected")
    end
  end
  
  def set_parent
    unless self.reference_location.blank?
      logger.debug "!- set_parent: self.reference_location = #{self.reference_location}"
      reference = extract_parent_path(self.reference_location)
      
      potential_parent = Page.find_by_location(reference)
      if potential_parent
        logger.debug "!- set_parent: setting parent to #{potential_parent.id}"
        self.parent = potential_parent
      else
        logger.debug "!- set_parent: no parent found for path #{reference}"
      end
    end
  end
  
  def set_slug
    if self.slug.blank?
      if self.suggested_slug.blank?
        self.slug = generate_slug(self.title)
      else
        self.slug = generate_slug(self.suggested_slug)
      end
    end
  end
  
  def set_cached_body
    unless self.body.blank?
      self.cached_body = RDiscount.new(self.body).to_html
    end
  end
  
  def set_location
    if self.parent.blank?
      self.location = "/#{self.slug}"
    else
      self.location = "#{parent.location}/#{self.slug}"
    end
  end

end

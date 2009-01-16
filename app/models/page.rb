class Page < ActiveRecord::Base
  include URLComponents
  
  validates_presence_of :title
  before_save :set_slug, :set_cached_body, :set_location
  attr_protected :slug, :cached_body
  
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
  
  private
  def set_slug
    self.slug = generate_slug(self.title)
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

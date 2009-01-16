require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Page do
  before(:each) do
    @valid_attributes = {
      :title => "value for title"
    }
    
    @missing_title = {
      :title => ""
    }
    
    @valid_with_markdown = {
      :title => "My Special Page!",
      :body => "_hello_"
    }
  end

  it "should create a new instance given valid attributes" do
    Page.create!(@valid_attributes)
  end
  
  it "should be invalid when no title is given" do
    Page.new(@missing_title).valid?.should be_false
  end
  
  it "should have a slug after save" do
    page = Page.create!(@valid_attributes)
    page.slug.should eql("value-for-title")
  end
  
  it "should cache the Markdown body as HTML" do
    page = Page.create!(@valid_with_markdown)
    page.cached_body.should eql("<p><em>hello</em></p>\n")
  end
end

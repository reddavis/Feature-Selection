require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Base" do
  
  before do
    @a = FeatureSelection::Base.new(data)
  end
  
  it "should include classes ham spam" do
    @a.classes.should include(:spam)
    @a.classes.should include(:ham)
  end
      
end

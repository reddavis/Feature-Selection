require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Chi Squared" do
  
  before do
    @a = FeatureSelection::ChiSquared.new(data)
  end
  
  it "should return an hash" do
    @a.rank_features.should be_a(Hash)
  end
  
  it "should give this a score of 48.0" do
    @a.rank_features[:spam]['this'].should == 48.0
  end
    
end

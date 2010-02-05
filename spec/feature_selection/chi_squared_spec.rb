require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Chi Squared" do
    
  it "should give this a score of 48.0" do
    a = FeatureSelection::ChiSquared.new(data, :temp_dir => temp_dir)
    a.rank_features[:spam]['this'].should == 48.0
  end
    
end

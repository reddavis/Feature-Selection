require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Mutual Information" do
  
  before do
    @a = FeatureSelection::MutualInformation.new(data)
  end
  
  it "should return an hash" do
    @a.rank_features.should be_a(Hash)
  end
    
end
